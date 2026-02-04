# Tauri + React + TypeScript Template

一个功能完整的桌面应用开发脚手架，基于 Tauri 2.0、React 18 和 TypeScript 构建。

## ✨ 特性

- ⚡ **Vite 6** - 极速的开发服务器和构建工具
- ⚛️ **React 18** - 现代化的 UI 框架
- 🦀 **Tauri 2.0** - 轻量级的跨平台桌面应用框架（基于 Rust）
- 📘 **TypeScript** - 类型安全的开发体验
- 🧪 **Vitest + Testing Library** - 完整的测试框架
- 🌍 **i18next** - 国际化支持（内置中英文）
- 🎨 **Tailwind CSS** - 原子化 CSS 样式系统
- 🌓 **深色模式** - 内置主题切换功能
- 📋 **规范化流程** - `.specify/` 目录提供完整的项目规范模板

## 📦 技术栈

### 前端
- React 18 + TypeScript
- Vite 6（开发服务器 & 构建工具）
- Tailwind CSS（样式）
- i18next + react-i18next（国际化）
- Lucide React（图标库）
- Vitest + Testing Library（测试）

### 后端
- Rust + Tauri 2.0
- 跨平台支持（macOS / Windows / Linux）

## 🚀 快速开始

### 前置要求

- **Node.js**: 22+ (推荐: 24)
- **Rust**: 1.77.2+ (推荐: 1.93+)
- **Tauri CLI**: 确保 `cargo tauri` 在你的 PATH 中可用
- **macOS**: 需要安装 Xcode Command Line Tools
- **Windows**: 需要安装 Visual Studio C++ Build Tools

### 安装依赖

从项目根目录运行：

```bash
npm install
```

可选（验证 Rust 依赖是否正常编译）：

```bash
cargo build --manifest-path src-tauri/Cargo.toml
```

### 开发模式

```bash
npm run tauri dev
```

这会启动 Vite 开发服务器并打开 Tauri 应用窗口。

**注意**：如果修改了 Rust 代码，需要重启 `npm run tauri dev`。

### 构建生产版本

```bash
npm run tauri build
```

构建完成后，可在 `src-tauri/target/release/bundle/` 目录找到打包好的应用。

## 🧪 测试

### 前端测试

```bash
npm test                    # 运行测试
npm run test:coverage       # 运行测试并生成覆盖率报告
```

### Rust 测试

```bash
cargo test --manifest-path src-tauri/Cargo.toml
```

### Rust 代码检查

```bash
# 格式化代码
cargo fmt --manifest-path src-tauri/Cargo.toml

# 运行 Clippy 检查
cargo clippy --manifest-path src-tauri/Cargo.toml -- -D warnings
```

## 📁 项目结构

```
.
├── .specify/              # 项目规范和文档模板
│   ├── templates/         # 规格文档、计划、任务清单模板
│   └── scripts/           # 辅助脚本
├── src/                   # 前端源码（React + TypeScript）
│   ├── components/        # React 组件
│   ├── services/          # 服务层（i18n 等）
│   ├── locales/           # 国际化翻译文件
│   ├── styles/            # 全局样式
│   ├── types/             # TypeScript 类型定义
│   ├── App.tsx            # 主应用组件
│   └── main.tsx           # 应用入口
├── src-tauri/             # Rust 后端代码
│   ├── src/
│   │   ├── lib.rs         # Tauri 应用主逻辑
│   │   └── main.rs        # 应用入口
│   ├── icons/             # 应用图标资源
│   ├── Cargo.toml         # Rust 依赖配置
│   └── tauri.conf.json    # Tauri 应用配置
├── tests/                 # 前端测试文件
├── index.html             # HTML 入口
├── vite.config.ts         # Vite 配置
├── vitest.config.ts       # Vitest 测试配置
├── tsconfig.json          # TypeScript 配置
└── package.json           # Node.js 依赖配置
```

## 🎯 如何使用此模板

### 方式 1：克隆仓库

```bash
git clone <your-repo-url> my-awesome-app
cd my-awesome-app
rm -rf .git
git init
npm install
```

### 方式 2：使用 degit

```bash
npx degit <your-username/repo-name> my-awesome-app
cd my-awesome-app
npm install
```

### 自定义你的应用

1. **修改应用名称和标识**：
   - `package.json` → `name` 字段
   - `src-tauri/tauri.conf.json` → `productName` 和 `identifier` 字段
   - `src-tauri/Cargo.toml` → `name` 字段

2. **替换应用图标**：
   - 将你的图标放入 `src-tauri/icons/` 目录

3. **修改翻译**：
   - 编辑 `src/locales/en.json` 和 `src/locales/zh.json`

4. **开始开发**：
   - 在 `src/` 中编写前端代码
   - 在 `src-tauri/src/` 中编写 Rust 命令

## 📚 示例代码

### 添加新的 Tauri Command

在 `src-tauri/src/lib.rs` 中添加：

```rust
#[tauri::command]
fn my_command(input: &str) -> String {
    format!("Received: {}", input)
}

// 然后在 invoke_handler 中注册：
.invoke_handler(tauri::generate_handler![greet, my_command])
```

在前端调用：

```typescript
import { invoke } from '@tauri-apps/api/core'

const result = await invoke<string>('my_command', { input: 'Hello' })
```

## 📖 学习资源

- [Tauri 官方文档](https://tauri.app/)
- [React 官方文档](https://react.dev/)
- [Vite 官方文档](https://vitejs.dev/)
- [TypeScript 官方文档](https://www.typescriptlang.org/)

## 📝 规范化开发流程

本模板内置了 `.specify/` 目录，提供了规范化的项目文档模板：

- **spec-template.md** - 功能规格文档模板
- **plan-template.md** - 实现计划模板
- **tasks-template.md** - 任务清单模板
- **checklist-template.md** - 检查清单模板

使用这些模板可以帮助你更好地规划和管理项目开发。

## 📄 License

MIT

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**开始构建你的桌面应用吧！** 🚀
