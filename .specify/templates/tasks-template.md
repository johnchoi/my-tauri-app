
---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**TDD Requirements (NON-NEGOTIABLE)**:
- **测试先行**：所有功能代码实现前 MUST 先编写对应的测试用例。
- **Red-Green-Refactor**：测试必须在实现前处于失败状态（Red），实现后通过（Green），然后重构优化（Refactor）。
- **测试分层**：必须包含单元测试（Domain/Application 层）、集成测试（跨层协作）、契约测试（API 接口）。
- **测试覆盖率**：Domain 层测试覆盖率 MUST ≥ 80%，关键用户路径 MUST 有端到端测试。
- **测试即文档**：测试命名遵循 `test_<行为>_when_<条件>_then_<预期结果>` 或等效模式。

**Tests Ordering**: Tests MUST be written and verified to FAIL before implementation tasks begin.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Tauri app (this repo)**:
  - Frontend (React + TS): `src/`
  - Frontend tests: `tests/`
  - Rust backend (Tauri): `src-tauri/src/`
  - Rust config: `src-tauri/tauri.conf.json`, `src-tauri/Cargo.toml`
- Paths shown below assume this repo structure - adjust based on plan.md structure

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit.tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  
  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T004 Define Tauri command contracts (name, params, return, errors)
- [ ] T005 [P] Implement input validation at boundaries (UI + Rust)
- [ ] T006 [P] Configure error mapping (Rust Result → UI-friendly errors)
- [ ] T007 [P] Configure logging/telemetry strategy (no sensitive data)
- [ ] T008 Confirm Tauri security posture changes (e.g., CSP, allowlists)
- [ ] T009 Setup environment configuration management (dev/prod)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1 (TDD REQUIRED - MUST be written FIRST) 🔴

> **TDD DISCIPLINE: Write these tests FIRST, ensure they FAIL before implementation**
>
> **Red-Green-Refactor Cycle**:
> 1. 🔴 Red: Write test → Run test → Verify it FAILS (test should fail because feature not implemented yet)
> 2. 🟢 Green: Implement minimum code to make test PASS
> 3. 🔵 Refactor: Improve code while keeping tests GREEN

**Test Coverage Requirements**:
- Frontend unit/integration tests via Vitest (critical paths covered)
- Contract-style tests for Tauri command invoke interfaces (Happy Path + Error Cases)
- Rust unit tests for command logic where applicable
- E2E tests when a user journey spans UI → invoke → side-effect

- [ ] T010 [P] [US1] **FRONTEND TEST** for [component/hook] in tests/test_[name].tsx
  - Test user-visible behavior (Testing Library)
  - Mock invoke side-effects
  - **VERIFY TEST FAILS** before proceeding to implementation tasks
- [ ] T011 [P] [US1] **CONTRACT TEST** for [Tauri command] in tests/test_[name].ts
  - Test invoke name, params, return shape, error mapping
  - **VERIFY TEST FAILS** before proceeding to implementation tasks
- [ ] T012 [P] [US1] **RUST TEST** for [command logic] in src-tauri/src/[module].rs
  - Test core logic and error cases
  - **VERIFY TEST FAILS** before proceeding to implementation tasks
- [ ] T013 [P] [US1] **E2E TEST** for [user journey] (optional) in tests/e2e/test_[name].ts
  - Test UI → invoke → side-effect
  - **VERIFY TEST FAILS** before proceeding to implementation

### Implementation for User Story 1

> **PREREQUISITE**: All tests above (T010-T013) MUST be written and FAILING before starting implementation

- [ ] T014 [P] [US1] Implement frontend state and UI in src/[location]/[file].tsx
  - **After implementation**: Run T010 frontend test → Should turn GREEN
- [ ] T015 [P] [US1] Implement invoke client wrapper in src/services/[service].ts
  - **After implementation**: Run T011 contract test → Should turn GREEN
- [ ] T016 [US1] Implement Rust command in src-tauri/src/[module].rs and register in src-tauri/src/lib.rs
  - **After implementation**: Run T012 Rust test → Should turn GREEN
- [ ] T017 [US1] Wire UI ↔ command integration and error mapping
  - **After implementation**: Run T010 + T011 (+ optional T013)
- [ ] T018 [US1] Add validation and user-friendly error messages at boundaries
  - **After implementation**: Run all error case tests → Should turn GREEN
- [ ] T019 [US1] Add minimal observability (no secrets) for debugging failures
- [ ] T020 [US1] **REFACTOR** while keeping all tests GREEN
  - Improve code structure, naming, and readability

**Checkpoint**: At this point:
- ✅ All tests (T010-T013) should be GREEN 🟢
- ✅ User Story 1 should be fully functional and testable independently
- ✅ Run frontend tests: `npm test`
- ✅ Run frontend coverage: `npm run test:coverage`
- ✅ Run Rust tests: `cargo test --manifest-path src-tauri/Cargo.toml`

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (TDD REQUIRED - MUST be written FIRST) 🔴

- [ ] T021 [P] [US2] **FRONTEND TEST** for [component/hook] in tests/test_[name].tsx
  - Test user-visible behavior (Testing Library)
  - **VERIFY TEST FAILS** before proceeding to implementation
- [ ] T022 [P] [US2] **CONTRACT TEST** for [Tauri command] in tests/test_[name].ts
  - Test invoke name, params, return shape, error mapping
  - **VERIFY TEST FAILS** before proceeding to implementation
- [ ] T023 [P] [US2] **RUST TEST** for [command logic] in src-tauri/src/[module].rs
  - Test error cases and edge conditions
  - **VERIFY TEST FAILS** before proceeding to implementation

### Implementation for User Story 2

> **PREREQUISITE**: All tests above (T021-T023) MUST be written and FAILING before starting implementation

- [ ] T024 [P] [US2] Implement frontend UI slice in src/[location]/[file].tsx
  - **After implementation**: Run T021 → Should turn GREEN
- [ ] T025 [P] [US2] Implement invoke client wrapper in src/services/[service].ts
  - **After implementation**: Run T022 → Should turn GREEN
- [ ] T026 [US2] Implement Rust command + registration in src-tauri/src/[module].rs and src-tauri/src/lib.rs
  - **After implementation**: Run T023 → Should turn GREEN
- [ ] T027 [US2] Wire UI ↔ command integration and error mapping
- [ ] T028 [US2] **REFACTOR** while keeping all tests GREEN

**Checkpoint**: At this point:
- ✅ All tests for User Stories 1 AND 2 should be GREEN 🟢
- ✅ Both stories should work independently
- ✅ Verify key user paths covered, and run: `npm test` + `cargo test --manifest-path src-tauri/Cargo.toml`

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (TDD REQUIRED - MUST be written FIRST) 🔴

- [ ] T029 [P] [US3] **FRONTEND TEST** for [component/hook] in tests/test_[name].tsx
  - Test user-visible behavior (Testing Library)
  - **VERIFY TEST FAILS** before proceeding to implementation
- [ ] T030 [P] [US3] **CONTRACT TEST** for [Tauri command] in tests/test_[name].ts
  - Test invoke name, params, return shape, error mapping
  - **VERIFY TEST FAILS** before proceeding to implementation
- [ ] T031 [P] [US3] **RUST TEST** for [command logic] in src-tauri/src/[module].rs
  - Test error cases and edge conditions
  - **VERIFY TEST FAILS** before proceeding to implementation

### Implementation for User Story 3

> **PREREQUISITE**: All tests above (T029-T031) MUST be written and FAILING before starting implementation

- [ ] T032 [P] [US3] Implement frontend UI slice in src/[location]/[file].tsx
  - **After implementation**: Run T029 → Should turn GREEN
- [ ] T033 [P] [US3] Implement invoke client wrapper in src/services/[service].ts
  - **After implementation**: Run T030 → Should turn GREEN
- [ ] T034 [US3] Implement Rust command + registration in src-tauri/src/[module].rs and src-tauri/src/lib.rs
  - **After implementation**: Run T031 → Should turn GREEN
- [ ] T035 [US3] **REFACTOR** while keeping all tests GREEN

**Checkpoint**: All user stories should now be independently functional with all tests GREEN 🟢

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX Code cleanup and refactoring (while keeping all tests GREEN 🟢)
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional frontend tests for edge cases (if needed) in tests/
- [ ] TXXX Security hardening
- [ ] TXXX Run quickstart.md validation
- [ ] TXXX **FINAL TDD CHECK**: Verify all tests GREEN (`npm test`, `cargo test --manifest-path src-tauri/Cargo.toml`) and critical paths covered

---

## Constitution Gates (must hold)

- Each task set MUST identify impacted areas (`src/`, `tests/`, `src-tauri/`) and include validation commands.
- **Security-by-default gates** (Tauri):
  - Any change involving Shell/file/network MUST document input validation and allowlist decisions
  - Errors MUST not leak sensitive data
- **TDD Gates** (NON-NEGOTIABLE):
  - Test tasks MUST precede implementation tasks for each user story
  - All tests MUST be verified to FAIL (🔴 Red) before implementation begins
  - Implementation tasks MUST verify tests turn GREEN (🟢) after completion
  - Refactoring tasks MUST keep all tests GREEN (🔵 Refactor)
  - Test naming MUST follow `test_<行为>_when_<条件>_then_<预期结果>` pattern

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests MUST be written and verified to FAIL before implementation
- UI before integration wiring (or in small vertical slices)
- Command contract before side-effect implementation
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch key tests for User Story 1 together (if tests requested):
Task: "Frontend test for [component/hook] in tests/test_[name].tsx"
Task: "Contract test for [Tauri command] in tests/test_[name].ts"
Task: "Rust test for [command logic] in src-tauri/src/[module].rs"

# Launch parallel implementation slices:
Task: "Implement UI slice in src/[location]/[file].tsx"
Task: "Implement invoke wrapper in src/services/[service].ts"
Task: "Implement Rust command in src-tauri/src/[module].rs"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence