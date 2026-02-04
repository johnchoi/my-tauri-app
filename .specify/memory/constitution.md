<!--
同步影响报告

- 版本变更：未定义（模板占位） → 1.0.0
- 原则变更：
  - 模板原则 1 → I. 安全默认（Tauri）
  - 模板原则 2 → II. 边界清晰：前端 / Rust 命令 / 系统
  - 模板原则 3 → III. 测试先行（NON-NEGOTIABLE）
  - 模板原则 4 → IV. 输入校验与错误处理
  - 模板原则 5 → V. 可维护性与不可变状态（React）
- 新增章节：
  - 技术与结构约束
  - 开发工作流与质量门禁
- 移除章节：无（仅替换模板占位符）
- 需要同步的模板：
  - ✅ 已更新：.specify/templates/plan-template.md
  - ✅ 已更新：.specify/templates/spec-template.md
  - ✅ 已更新：.specify/templates/tasks-template.md
  - ✅ 已更新：.specify/templates/checklist-template.md
  - ⚠ 待处理：.specify/templates/commands/*.md（目录不存在）
- 遗留 TODO：无
-->

# Tauri + React + TypeScript 模板项目宪章

## 核心原则

### I. 安全默认（Tauri）
- 所有系统边界能力（文件系统、网络、Shell、打开外部链接等）MUST 通过 Tauri/Rust 层集中实现与审计；前端 UI 不直接拼接系统命令或路径。
- 使用 `@tauri-apps/plugin-shell` 或类似能力时，MUST 采用“白名单 + 参数数组”方式调用；任何来自用户/外部的数据 MUST 校验后再进入系统边界。
- 配置层安全策略（例如 `src-tauri/tauri.conf.json`）的放宽（如禁用 CSP）MUST 在方案/PR 中明确原因、影响范围与替代方案。

### II. 边界清晰：前端 / Rust 命令 / 系统
- UI（`src/`）只负责展示与交互；跨边界能力通过 `invoke` 调用 Tauri command（Rust）完成。
- Rust 层（`src-tauri/src/`）负责与操作系统/权限相关的逻辑，并用类型与序列化边界（Serde）定义稳定输入输出。
- 跨边界契约（command 名称、参数结构、返回值结构）MUST 可追踪、可测试，并在变更时同步更新调用方与测试。

### III. 测试先行（NON-NEGOTIABLE）
- 对于任何新功能/缺陷修复，MUST 先写测试（Red），再实现使其通过（Green），最后在保持测试通过的前提下重构（Refactor）。
- 前端逻辑使用 Vitest：MUST 至少覆盖关键用户路径的组件行为与核心业务逻辑；推荐提供覆盖率报告（`npm run test:coverage`）。
- Rust 逻辑使用 `cargo test --manifest-path src-tauri/Cargo.toml`：MUST 覆盖 command 的关键分支与错误场景。

### IV. 输入校验与错误处理
- 所有外部输入（UI 表单、文件选择结果、URL、命令参数、持久化数据）MUST 在边界处校验；校验失败 MUST 返回可理解的错误信息，并避免泄露敏感信息。
- 错误处理 MUST 结构化：在 Rust 层使用 `Result`/错误类型明确失败原因；在前端把错误映射为用户可理解的提示。

### V. 可维护性与不可变状态（React）
- 前端状态更新 MUST 遵循不可变模式（创建新对象/数组），禁止就地修改。
- 代码组织 MUST 倾向“小文件、职责单一”；避免把与 UI 无关的业务逻辑塞进组件。
- 依赖引入 MUST 克制：新增依赖前必须说明必要性与替代方案，并确保与现有技术栈一致。

## 技术与结构约束
- 本仓库为 Tauri + React + TypeScript 项目：前端代码位于 `src/`，后端（Rust）位于 `src-tauri/`。
- 变更涉及跨边界能力（Rust commands / plugin 权限 / Tauri 配置）时，MUST 同步更新：
  - 调用方 TypeScript 代码
  - 对应测试（前端与/或 Rust）
  - 影响说明（安全/权限/平台兼容性）
- 国际化（i18next）与主题（深色模式）属于跨切面能力：新增用户可见文本 MUST 通过 i18n 字典管理，禁止硬编码文案。

## 开发工作流与质量门禁
- 每个可交付变更 MUST 提供可复现的验证命令（至少包含以下之一，按改动范围选择）：
  - `npm test`
  - `npm run test:coverage`
  - `cargo test --manifest-path src-tauri/Cargo.toml`
  - `npm run tauri build`（涉及打包/配置/命令变更时）
- 当变更引入安全敏感行为（Shell/文件系统/网络）时，MUST 进行一次安全自查：输入来源、权限边界、错误信息、是否存在命令注入/路径穿越风险。

## Governance
- 本宪章高于其他非强制约定；若与其他文档冲突，以本宪章为准。
- 任何修改宪章的 PR MUST：
  - 更新版本号（语义化：MAJOR/MINOR/PATCH）并解释升级原因
  - 说明对现有规范/模板的影响与迁移策略
- 宪章合规检查是评审门禁的一部分：计划文档（plan）、规格文档（spec）与任务清单（tasks）必须能映射到本宪章的原则与门禁。

**Version**: 1.0.0 | **Ratified**: 2026-02-04 | **Last Amended**: 2026-02-04
