#!/usr/bin/env bash

set -e

JSON_MODE=false
SHORT_NAME=""
BRANCH_NUMBER=""
ARGS=()
i=1
while [ $i -le $# ]; do
    arg="${!i}"
    case "$arg" in
        --json) 
            JSON_MODE=true 
            ;;
        --short-name)
            if [ $((i + 1)) -gt $# ]; then
                echo 'Error: --short-name requires a value' >&2
                exit 1
            fi
            i=$((i + 1))
            next_arg="${!i}"
            # Check if the next argument is another option (starts with --)
            if [[ "$next_arg" == --* ]]; then
                echo 'Error: --short-name requires a value' >&2
                exit 1
            fi
            SHORT_NAME="$next_arg"
            ;;
        --number)
            if [ $((i + 1)) -gt $# ]; then
                echo 'Error: --number requires a value' >&2
                exit 1
            fi
            i=$((i + 1))
            next_arg="${!i}"
            if [[ "$next_arg" == --* ]]; then
                echo 'Error: --number requires a value' >&2
                exit 1
            fi
            BRANCH_NUMBER="$next_arg"
            ;;
        --help|-h) 
            echo "Usage: $0 [--json] [--short-name <name>] [--number N] <feature_description>"
            echo ""
            echo "Options:"
            echo "  --json              Output in JSON format"
            echo "  --short-name <name> Provide a custom short name (2-4 words) for the branch"
            echo "  --number N          Specify branch number manually (overrides auto-detection)"
            echo "  --help, -h          Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 'Add user authentication system' --short-name 'user-auth'"
            echo "  $0 'Implement OAuth2 integration for API' --number 5"
            exit 0
            ;;
        *) 
            ARGS+=("$arg") 
            ;;
    esac
    i=$((i + 1))
done

FEATURE_DESCRIPTION="${ARGS[*]}"
if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "Usage: $0 [--json] [--short-name <name>] [--number N] <feature_description>" >&2
    exit 1
fi

# Function to find the repository root by searching for existing project markers
find_repo_root() {
    local dir="$1"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ] || [ -d "$dir/.specify" ]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Function to get highest number from specs directory
get_highest_from_specs() {
    local specs_dir="$1"
    local highest=0
    
    if [ -d "$specs_dir" ]; then
        for dir in "$specs_dir"/*; do
            [ -d "$dir" ] || continue
            dirname=$(basename "$dir")
            number=$(echo "$dirname" | grep -o '^[0-9]\+' || echo "0")
            number=$((10#$number))
            if [ "$number" -gt "$highest" ]; then
                highest=$number
            fi
        done
    fi
    
    echo "$highest"
}

# Function to get highest number from git branches
get_highest_from_branches() {
    local highest=0
    
    # Get all branches (local and remote)
    branches=$(git branch -a 2>/dev/null || echo "")
    
    if [ -n "$branches" ]; then
        while IFS= read -r branch; do
            # Clean branch name: remove leading markers and remote prefixes
            clean_branch=$(echo "$branch" | sed 's/^[* ]*//; s|^remotes/[^/]*/||')
            
            # Extract feature number if branch matches pattern ###-*
            if echo "$clean_branch" | grep -q '^[0-9]\{3\}-'; then
                number=$(echo "$clean_branch" | grep -o '^[0-9]\{3\}' || echo "0")
                number=$((10#$number))
                if [ "$number" -gt "$highest" ]; then
                    highest=$number
                fi
            fi
        done <<< "$branches"
    fi
    
    echo "$highest"
}

# Function to check existing branches (local and remote) and return next available number
check_existing_branches() {
    local existing_specs_dir="$1"

    # Fetch all remotes to get latest branch info (suppress errors if no remotes)
    git fetch --all --prune 2>/dev/null || true

    # Get highest number from ALL branches (not just matching short name)
    local highest_branch=$(get_highest_from_branches)

    # Get highest number from ALL specs (not just matching short name)
    local highest_spec=$(get_highest_from_specs "$existing_specs_dir")

    # Take the maximum of both
    local max_num=$highest_branch
    if [ "$highest_spec" -gt "$max_num" ]; then
        max_num=$highest_spec
    fi

    # Return next number
    echo $((max_num + 1))
}

# Function to clean and format a branch name
clean_branch_name() {
    local name="$1"
    echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//'
}

# Resolve repository root. Prefer git information when available, but fall back
# to searching for repository markers so the workflow still functions in repositories that
# were initialised with --no-git.
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if git rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
    HAS_GIT=true
else
    REPO_ROOT="$(find_repo_root "$SCRIPT_DIR")"
    if [ -z "$REPO_ROOT" ]; then
        echo "Error: Could not determine repository root. Please run this script from within the repository." >&2
        exit 1
    fi
    HAS_GIT=false
fi

cd "$REPO_ROOT"

# EXISTING_SPECS_DIR 用于检查现有分支号，必须指向主仓库的 specs（即使当前在 worktree 里）
# 如果当前在 worktree，需要找到主仓库路径
MAIN_REPO_ROOT="$REPO_ROOT"
if [ "$HAS_GIT" = true ]; then
    # 检查是否在 worktree 中（git rev-parse --git-common-dir 会返回主仓库 .git 路径）
    GIT_COMMON_DIR="$(git rev-parse --git-common-dir 2>/dev/null || echo "")"
    if [ -n "$GIT_COMMON_DIR" ] && [ "$GIT_COMMON_DIR" != ".git" ]; then
        # 在 worktree 中，获取主仓库路径
        MAIN_REPO_ROOT="$(cd "$GIT_COMMON_DIR/.." && pwd)"
    fi
fi

EXISTING_SPECS_DIR="$MAIN_REPO_ROOT/specs"
mkdir -p "$EXISTING_SPECS_DIR"

# Function to generate branch name with stop word filtering and length filtering
generate_branch_name() {
    local description="$1"
    
    # Common stop words to filter out
    local stop_words="^(i|a|an|the|to|for|of|in|on|at|by|with|from|is|are|was|were|be|been|being|have|has|had|do|does|did|will|would|should|could|can|may|might|must|shall|this|that|these|those|my|your|our|their|want|need|add|get|set)$"
    
    # Convert to lowercase and split into words
    local clean_name=$(echo "$description" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/ /g')
    
    # Filter words: remove stop words and words shorter than 3 chars (unless they're uppercase acronyms in original)
    local meaningful_words=()
    for word in $clean_name; do
        # Skip empty words
        [ -z "$word" ] && continue
        
        # Keep words that are NOT stop words AND (length >= 3 OR are potential acronyms)
        if ! echo "$word" | grep -qiE "$stop_words"; then
            if [ ${#word} -ge 3 ]; then
                meaningful_words+=("$word")
            elif echo "$description" | grep -q "\b${word^^}\b"; then
                # Keep short words if they appear as uppercase in original (likely acronyms)
                meaningful_words+=("$word")
            fi
        fi
    done
    
    # If we have meaningful words, use first 3-4 of them
    if [ ${#meaningful_words[@]} -gt 0 ]; then
        local max_words=3
        if [ ${#meaningful_words[@]} -eq 4 ]; then max_words=4; fi
        
        local result=""
        local count=0
        for word in "${meaningful_words[@]}"; do
            if [ $count -ge $max_words ]; then break; fi
            if [ -n "$result" ]; then result="$result-"; fi
            result="$result$word"
            count=$((count + 1))
        done
        echo "$result"
    else
        # Fallback to original logic if no meaningful words found
        local cleaned=$(clean_branch_name "$description")
        echo "$cleaned" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//'
    fi
}

# Generate branch name
if [ -n "$SHORT_NAME" ]; then
    # Use provided short name, just clean it up
    BRANCH_SUFFIX=$(clean_branch_name "$SHORT_NAME")
else
    # Generate from description with smart filtering
    BRANCH_SUFFIX=$(generate_branch_name "$FEATURE_DESCRIPTION")
fi

# Determine branch number
if [ -z "$BRANCH_NUMBER" ]; then
    if [ "$HAS_GIT" = true ]; then
        # Check existing branches on remotes
        BRANCH_NUMBER=$(check_existing_branches "$EXISTING_SPECS_DIR")
    else
        # Fall back to local directory check
        HIGHEST=$(get_highest_from_specs "$EXISTING_SPECS_DIR")
        BRANCH_NUMBER=$((HIGHEST + 1))
    fi
fi

# Force base-10 interpretation to prevent octal conversion (e.g., 010 → 8 in octal, but should be 10 in decimal)
FEATURE_NUM=$(printf "%03d" "$((10#$BRANCH_NUMBER))")
BRANCH_NAME="${FEATURE_NUM}-${BRANCH_SUFFIX}"

# GitHub enforces a 244-byte limit on branch names
# Validate and truncate if necessary
MAX_BRANCH_LENGTH=244
if [ ${#BRANCH_NAME} -gt $MAX_BRANCH_LENGTH ]; then
    # Calculate how much we need to trim from suffix
    # Account for: feature number (3) + hyphen (1) = 4 chars
    MAX_SUFFIX_LENGTH=$((MAX_BRANCH_LENGTH - 4))
    
    # Truncate suffix at word boundary if possible
    TRUNCATED_SUFFIX=$(echo "$BRANCH_SUFFIX" | cut -c1-$MAX_SUFFIX_LENGTH)
    # Remove trailing hyphen if truncation created one
    TRUNCATED_SUFFIX=$(echo "$TRUNCATED_SUFFIX" | sed 's/-$//')
    
    ORIGINAL_BRANCH_NAME="$BRANCH_NAME"
    BRANCH_NAME="${FEATURE_NUM}-${TRUNCATED_SUFFIX}"
    
    >&2 echo "[specify] Warning: Branch name exceeded GitHub's 244-byte limit"
    >&2 echo "[specify] Original: $ORIGINAL_BRANCH_NAME (${#ORIGINAL_BRANCH_NAME} bytes)"
    >&2 echo "[specify] Truncated to: $BRANCH_NAME (${#BRANCH_NAME} bytes)"
fi

TEMPLATE="$REPO_ROOT/.specify/templates/spec-template.md"

# ---- worktree mode switches ----
USE_WORKTREE="${SPEC_KIT_USE_WORKTREE:-0}"
# 推荐把 worktree 放到仓库外，避免污染主仓库文件变更列表
WORKTREES_BASE="${SPEC_KIT_WORKTREES_BASE:-"$REPO_ROOT/../.worktrees/$(basename "$REPO_ROOT")"}"

# 生成 worktree 路径（每个 feature 一个目录）
WT_DIR="$WORKTREES_BASE/$BRANCH_NAME"

abs_path() {
  python3 - <<'PY' "$1"
import os,sys
print(os.path.realpath(sys.argv[1]))
PY
}

seed_branch_with_spec_commit() {
    local branch="$1"
    local spec_rel_path="$2"
    local base_repo="$3"

    # 必须在主仓库里执行（如果当前在 worktree，需要切到主仓库）
    local original_dir="$(pwd)"
    cd "$base_repo"

    # 步骤1：在当前分支上创建 spec.md 并提交
    local spec_dir="$(dirname "$spec_rel_path")"
    mkdir -p "$spec_dir"

    if [ -f "$TEMPLATE" ]; then
        cp "$TEMPLATE" "$spec_rel_path"
    else
        touch "$spec_rel_path"
    fi

    git add "$spec_rel_path"

    local identity_name="${SPEC_KIT_GIT_IDENTITY_NAME:-SpecKit}"
    local identity_email="${SPEC_KIT_GIT_IDENTITY_EMAIL:-spec-kit@local}"

    if $JSON_MODE; then
        GIT_AUTHOR_NAME="$identity_name" \
        GIT_AUTHOR_EMAIL="$identity_email" \
        GIT_COMMITTER_NAME="$identity_name" \
        GIT_COMMITTER_EMAIL="$identity_email" \
            git commit --quiet -m "chore(spec): seed $spec_rel_path" 1>&2
    else
        GIT_AUTHOR_NAME="$identity_name" \
        GIT_AUTHOR_EMAIL="$identity_email" \
        GIT_COMMITTER_NAME="$identity_name" \
        GIT_COMMITTER_EMAIL="$identity_email" \
            git commit -m "chore(spec): seed $spec_rel_path"
    fi

    # 步骤2：基于当前 HEAD 创建新分支
    git branch "$branch"

    # 返回原目录
    cd "$original_dir"
}

if [ "$HAS_GIT" = true ]; then
    if [ "$USE_WORKTREE" = "1" ]; then
        mkdir -p "$WORKTREES_BASE"

        SPEC_REL_PATH="specs/$BRANCH_NAME/spec.md"

        # 先创建 spec（写入 branch commit），再创建 worktree。
        # 这样后续生成新 feature 时能够稳定递增编号（避免多开时重复序号）。
        if ! git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
            seed_branch_with_spec_commit "$BRANCH_NAME" "$SPEC_REL_PATH" "$MAIN_REPO_ROOT"
        fi

        # 从主仓库创建 worktree
        cd "$MAIN_REPO_ROOT"
        if $JSON_MODE; then
            git worktree add --quiet "$WT_DIR" "$BRANCH_NAME" 1>&2
        else
            git worktree add "$WT_DIR" "$BRANCH_NAME"
        fi
        TARGET_ROOT="$(abs_path "$WT_DIR")"

        # Auto-install dependencies in new worktree
        if [ -d "$TARGET_ROOT/backend" ] && [ -f "$TARGET_ROOT/backend/pyproject.toml" ]; then
            if ! $JSON_MODE; then
                echo ""
                echo "🔧 Setting up backend dependencies in worktree..."
            fi
            cd "$TARGET_ROOT/backend"
            if command -v uv >/dev/null 2>&1; then
                if $JSON_MODE; then
                    uv sync --all-extras --quiet 1>&2 2>/dev/null || true
                else
                    uv sync --all-extras || echo "⚠️  Warning: Failed to install backend dependencies"
                fi
                if ! $JSON_MODE; then
                    echo "✅ Backend dependencies installed"
                fi
            else
                if ! $JSON_MODE; then
                    echo "⚠️  Warning: 'uv' not found, skipping backend dependency installation"
                    echo "   Run 'cd backend && uv sync --all-extras' manually"
                fi
            fi
            cd "$MAIN_REPO_ROOT"
        fi

        if [ -d "$TARGET_ROOT/web" ] && [ -f "$TARGET_ROOT/web/package.json" ]; then
            if ! $JSON_MODE; then
                echo ""
                echo "🔧 Setting up web dependencies in worktree..."
            fi
            cd "$TARGET_ROOT/web"
            if command -v npm >/dev/null 2>&1; then
                if $JSON_MODE; then
                    npm install --silent 1>&2 2>/dev/null || true
                else
                    npm install || echo "⚠️  Warning: Failed to install web dependencies"
                fi
                if ! $JSON_MODE; then
                    echo "✅ Web dependencies installed"
                fi
            else
                if ! $JSON_MODE; then
                    echo "⚠️  Warning: 'npm' not found, skipping web dependency installation"
                    echo "   Run 'cd web && npm install' manually"
                fi
            fi
            cd "$MAIN_REPO_ROOT"
        fi
    else
        # 非 worktree 模式保持原有行为：直接在当前目录创建并切换分支
        if $JSON_MODE; then
            git checkout --quiet -b "$BRANCH_NAME" 1>&2
        else
            git checkout -b "$BRANCH_NAME"
        fi
        TARGET_ROOT="$(abs_path "$REPO_ROOT")"
    fi
else
    >&2 echo "[specify] Warning: Git repository not detected; skipped branch creation for $BRANCH_NAME"
    TARGET_ROOT="$(abs_path "$REPO_ROOT")"
fi

# ---- IMPORTANT: specs 目录统一使用 specs/ ----
# 所有 speckit 产物都放在仓库根的 specs/<branch> 目录下
SPECS_DIR="$TARGET_ROOT/specs/$BRANCH_NAME"
mkdir -p "$SPECS_DIR"
SPEC_FILE="$SPECS_DIR/spec.md"

# worktree 模式下：spec.md 已经在 seed commit 里写入，这里不要覆盖
if [ "$USE_WORKTREE" != "1" ]; then
    if [ -f "$TEMPLATE" ]; then cp "$TEMPLATE" "$SPEC_FILE"; else touch "$SPEC_FILE"; fi
fi

# Set the SPECIFY_FEATURE environment variable for the current session
export SPECIFY_FEATURE="$BRANCH_NAME"

if $JSON_MODE; then
    printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s","WORKTREE_DIR":"%s"}\n' \
        "$BRANCH_NAME" "$SPEC_FILE" "$FEATURE_NUM" "$TARGET_ROOT"
else
    echo "BRANCH_NAME: $BRANCH_NAME"
    echo "SPEC_FILE: $SPEC_FILE"
    echo "FEATURE_NUM: $FEATURE_NUM"
    echo "SPECIFY_FEATURE environment variable set to: $BRANCH_NAME"
    if [ "$USE_WORKTREE" = "1" ] && [ "$HAS_GIT" = true ]; then
        echo "WORKTREE_DIR: $TARGET_ROOT"
    fi
fi
