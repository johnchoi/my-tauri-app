# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]  
**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]
**Project Type**: [single/web/mobile - determines source structure]  
**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]  
**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]  
**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- ✅ 边界与责任：方案是否只改动本子项目内实现？若跨项目，是否明确公开接口/契约与负责人评审？
- ✅ 影响说明（Impact-First）：是否在计划中写明影响子项目、依赖变化、风险与回滚？
- ✅ 可独立验证：是否给出可复现的验证命令（优先 `scripts/monorepo/run-checks.sh <project>` 或对应 `pytest` 等）？
- ✅ 依赖纪律：若新增/变更依赖，是否同步更新 `docs/monorepo/dependencies.md`（必要时登记冲突）？
- ✅ 最小流程与门禁：是否避免无关重构混入，且门禁可自动执行？
- ✅ DDD 架构纪律（Backend 专属）：若涉及 backend 项目，是否按 DDD 分层设计（Domain/Application/Infrastructure/Interfaces）？是否遵循标准目录结构（见宪章 1.4.0）？是否确保依赖方向正确（由外向内）？是否避免领域层依赖框架？是否遵循文件命名规范（entities.py、repository.py、commands.py、queries.py、handlers.py、dtos.py、model.py）？
- ✅ TDD 纪律（NON-NEGOTIABLE）：是否计划先编写测试再实现功能代码？是否明确测试分层策略（单元/集成/契约/端到端）？是否设定测试覆盖率目标（Domain 层 ≥ 80%）？

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── app/
│   ├── domain/                 # 领域层（核心业务逻辑）
│   │   └── <domain>/           # 领域模块（如 tenant、user、subscription、marketing）
│   │       ├── entities.py     # 领域实体（必需）
│   │       ├── repository.py   # Repository 接口（必需）
│   │       ├── value_objects.py # 值对象（可选）
│   │       └── services.py     # 领域服务（可选，仅纯业务逻辑）
│   ├── application/            # 应用层（用例编排）
│   │   └── <domain>/           # 应用模块（与领域模块对应）
│   │       ├── commands.py     # 命令（写操作，必需）
│   │       ├── queries.py      # 查询（读操作，必需）
│   │       ├── handlers.py     # 命令/查询处理器（必需）
│   │       └── dtos.py         # 数据传输对象（必需）
│   ├── infrastructure/         # 基础设施层（技术实现）
│   │   ├── persistence/        # 持久化（按领域组织）
│   │   │   └── <domain>/
│   │   │       ├── model.py    # ORM 模型（必需）
│   │   │       └── repository.py # Repository 实现（必需）
│   │   ├── middleware/         # 中间件
│   │   ├── auth/               # 认证服务
│   │   ├── gateways/           # 外部系统网关
│   │   └── integrations/       # 第三方集成
│   └── interfaces/             # 接口层（对外暴露）
│       └── api/v1/             # API v1
│           ├── auth/           # 认证端点
│           ├── public/         # 公开端点
│           └── schemas/        # API Schemas（按领域组织）
└── tests/
    ├── unit/                   # 单元测试（Domain/Application 层）
    ├── integration/            # 集成测试（跨层协作）
    └── contract/               # 契约测试（API 接口）

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |