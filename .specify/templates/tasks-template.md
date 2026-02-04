
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

- **Single project**: `src/`, `tests/` at repository root
- **Web app (DDD structure)**:
  - Domain: `backend/app/domain/<domain>/entities.py`, `repository.py`, `value_objects.py`, `services.py`
  - Application: `backend/app/application/<domain>/commands.py`, `queries.py`, `handlers.py`, `dtos.py`
  - Infrastructure: `backend/app/infrastructure/persistence/<domain>/model.py`, `repository.py`
  - Interfaces: `backend/app/interfaces/api/v1/auth/`, `schemas/`
  - Tests: `backend/tests/unit/`, `integration/`, `contract/`
  - Frontend: `frontend/src/components/`, `pages/`, `services/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure
- **DDD 文件命名规范**: 必须遵循宪章 1.4.0 定义的标准文件名（entities.py、repository.py、commands.py、queries.py、handlers.py、dtos.py、model.py）

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

- [ ] T004 Setup database schema and migrations framework
- [ ] T005 [P] Implement authentication/authorization framework
- [ ] T006 [P] Setup API routing and middleware structure
- [ ] T007 Create base models/entities that all stories depend on
- [ ] T008 Configure error handling and logging infrastructure
- [ ] T009 Setup environment configuration management

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
- Unit tests for Domain layer business logic (MUST cover ≥ 80%)
- Integration tests for Application layer use cases
- Contract tests for API endpoints (Happy Path + Error Cases)
- E2E test for critical user journey

- [ ] T010 [P] [US1] **UNIT TEST** for [Domain Entity/ValueObject/Service] in tests/unit/test_[name].py
  - Test business rules and domain logic
  - Mock all external dependencies
  - **VERIFY TEST FAILS** before proceeding to T012-T013
- [ ] T011 [P] [US1] **CONTRACT TEST** for [API endpoint] in tests/contract/test_[name].py
  - Test request/response format, status codes, error handling
  - **VERIFY TEST FAILS** before proceeding to T015
- [ ] T012 [P] [US1] **INTEGRATION TEST** for [use case workflow] in tests/integration/test_[name].py
  - Test cross-layer collaboration (Application → Domain → Infrastructure)
  - Use real database/services (test containers)
  - **VERIFY TEST FAILS** before proceeding to T014
- [ ] T013 [P] [US1] **E2E TEST** for [user journey] in tests/e2e/test_[name].py
  - Test complete user flow from entry to data persistence
  - **VERIFY TEST FAILS** before proceeding to implementation

### Implementation for User Story 1

> **PREREQUISITE**: All tests above (T010-T013) MUST be written and FAILING before starting implementation

- [ ] T014 [P] [US1] Create [Entity1] model in src/models/[entity1].py
  - **After implementation**: Run T010 unit test → Should turn GREEN 🟢
- [ ] T015 [P] [US1] Create [Entity2] model in src/models/[entity2].py
  - **After implementation**: Run T010 unit test → Should turn GREEN 🟢
- [ ] T016 [US1] Implement [Service] in src/services/[service].py (depends on T014, T015)
  - **After implementation**: Run T012 integration test → Should turn GREEN 🟢
- [ ] T017 [US1] Implement [endpoint/feature] in src/[location]/[file].py
  - **After implementation**: Run T011 contract test → Should turn GREEN 🟢
- [ ] T018 [US1] Add validation and error handling
  - **After implementation**: Run all error case tests → Should turn GREEN 🟢
- [ ] T019 [US1] Add logging for user story 1 operations
- [ ] T020 [US1] **REFACTOR** code while keeping all tests GREEN 🔵
  - Improve code structure, naming, and readability
  - **CRITICAL**: All tests MUST remain GREEN during refactoring

**Checkpoint**: At this point:
- ✅ All tests (T010-T013) should be GREEN 🟢
- ✅ User Story 1 should be fully functional and testable independently
- ✅ Run full test suite: `pytest tests/ -v --cov=src --cov-report=term`
- ✅ Verify Domain layer coverage ≥ 80%

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (TDD REQUIRED - MUST be written FIRST) 🔴

- [ ] T021 [P] [US2] **UNIT TEST** for [Domain logic] in tests/unit/test_[name].py
  - **VERIFY TEST FAILS** before proceeding to implementation
- [ ] T022 [P] [US2] **CONTRACT TEST** for [API endpoint] in tests/contract/test_[name].py
  - **VERIFY TEST FAILS** before proceeding to implementation
- [ ] T023 [P] [US2] **INTEGRATION TEST** for [use case] in tests/integration/test_[name].py
  - **VERIFY TEST FAILS** before proceeding to implementation

### Implementation for User Story 2

> **PREREQUISITE**: All tests above (T021-T023) MUST be written and FAILING before starting implementation

- [ ] T024 [P] [US2] Create [Entity] model in src/models/[entity].py
  - **After implementation**: Run T021 → Should turn GREEN 🟢
- [ ] T025 [US2] Implement [Service] in src/services/[service].py
  - **After implementation**: Run T023 → Should turn GREEN 🟢
- [ ] T026 [US2] Implement [endpoint/feature] in src/[location]/[file].py
  - **After implementation**: Run T022 → Should turn GREEN 🟢
- [ ] T027 [US2] Integrate with User Story 1 components (if needed)
- [ ] T028 [US2] **REFACTOR** code while keeping all tests GREEN 🔵

**Checkpoint**: At this point:
- ✅ All tests for User Stories 1 AND 2 should be GREEN 🟢
- ✅ Both stories should work independently
- ✅ Verify test coverage remains ≥ 80% for Domain layer

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (TDD REQUIRED - MUST be written FIRST) 🔴

- [ ] T029 [P] [US3] **UNIT TEST** for [Domain logic] in tests/unit/test_[name].py
  - **VERIFY TEST FAILS** before proceeding to implementation
- [ ] T030 [P] [US3] **CONTRACT TEST** for [API endpoint] in tests/contract/test_[name].py
  - **VERIFY TEST FAILS** before proceeding to implementation
- [ ] T031 [P] [US3] **INTEGRATION TEST** for [use case] in tests/integration/test_[name].py
  - **VERIFY TEST FAILS** before proceeding to implementation

### Implementation for User Story 3

> **PREREQUISITE**: All tests above (T029-T031) MUST be written and FAILING before starting implementation

- [ ] T032 [P] [US3] Create [Entity] model in src/models/[entity].py
  - **After implementation**: Run T029 → Should turn GREEN 🟢
- [ ] T033 [US3] Implement [Service] in src/services/[service].py
  - **After implementation**: Run T031 → Should turn GREEN 🟢
- [ ] T034 [US3] Implement [endpoint/feature] in src/[location]/[file].py
  - **After implementation**: Run T030 → Should turn GREEN 🟢
- [ ] T035 [US3] **REFACTOR** code while keeping all tests GREEN 🔵

**Checkpoint**: All user stories should now be independently functional with all tests GREEN 🟢

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX Code cleanup and refactoring (while keeping all tests GREEN 🟢)
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit tests for edge cases (if needed) in tests/unit/
- [ ] TXXX Security hardening
- [ ] TXXX Run quickstart.md validation
- [ ] TXXX **FINAL TDD CHECK**: Verify all tests GREEN 🟢, coverage ≥ 80% for Domain layer

---

## Constitution Gates (must hold)

- Each task set MUST identify impacted subprojects and include validation commands.
- If any task changes cross-project dependencies, include companion tasks to update:
  - `docs/monorepo/dependencies.md`
  - `docs/monorepo/templates/impact-report.md` (fill an impact report alongside the change)
  - `docs/monorepo/dependency-conflicts.yaml` (if conflicts/cycles suspected)
- **Backend DDD Architecture Gates** (Backend 专属):
  - Backend tasks MUST be organized by DDD layer (Domain → Application → Infrastructure → Presentation → Bootstrap)
  - Domain layer tasks MUST NOT introduce framework dependencies
  - Repository interfaces MUST be defined in Domain layer, implementations in Infrastructure layer
  - Application layer tasks MUST only orchestrate use cases, not contain business rules
  - Each backend implementation task MUST include DDD layer self-check validation
- **TDD Gates** (NON-NEGOTIABLE):
  - Test tasks MUST precede implementation tasks for each user story
  - All tests MUST be verified to FAIL (🔴 Red) before implementation begins
  - Implementation tasks MUST verify tests turn GREEN (🟢) after completion
  - Refactoring tasks MUST keep all tests GREEN (🔵 Refactor)
  - Final checkpoint MUST verify Domain layer test coverage ≥ 80%
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

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
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
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in tests/contract/test_[name].py"
Task: "Integration test for [user journey] in tests/integration/test_[name].py"

# Launch all models for User Story 1 together:
Task: "Create [Entity1] model in src/models/[entity1].py"
Task: "Create [Entity2] model in src/models/[entity2].py"
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