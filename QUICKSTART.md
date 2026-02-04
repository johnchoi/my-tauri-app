# Tauri App - Quickstart

这是一个 Tauri (Rust) + React (Vite) 桌面应用模板。

## 前置要求

- Node.js: 22+ (推荐: 24)
- Rust: 1.77.2+ (推荐: 1.93+)
- Tauri CLI: `cargo tauri` 在你的 PATH 中可用
- macOS: 需要安装 Xcode Command Line Tools
- Windows: 需要安装 Visual Studio C++ Build Tools

## 安装

从项目根目录运行：

```bash
npm install
```

可选（验证 Rust 依赖是否正常编译）：

```bash
cargo build --manifest-path src-tauri/Cargo.toml
```

## 开发模式运行

从项目根目录运行：

```bash
npm run tauri dev
```

说明：
- 这会启动 Vite 开发服务器并打开 Tauri 应用窗口
- 如果修改了 Rust 代码，需要重启 `npm run tauri dev`

## 构建生产版本

```bash
npm run tauri build
```

构建产物位于 `src-tauri/target/release/bundle/` 目录。

## 测试

前端测试：

```bash
npm test                    # 运行测试
npm run test:coverage       # 生成测试覆盖率报告
```

Rust 测试：

```bash
cargo test --manifest-path src-tauri/Cargo.toml
```

Rust 代码格式化和检查：

```bash
cargo fmt --manifest-path src-tauri/Cargo.toml
cargo clippy --manifest-path src-tauri/Cargo.toml -- -D warnings
```

## 下一步

1. 修改 `src/App.tsx` 开始编写前端界面
2. 在 `src-tauri/src/lib.rs` 中添加 Rust 命令
3. 自定义应用名称和图标（见 README.md）

Happy coding! 🚀
