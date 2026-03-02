<!-- opencode.nvim 插件集成指南 (sudo-tee/opencode.nvim) -->
# OpenCode Neovim 集成指南

本文档介绍如何在 Neovim 中使用 `sudo-tee/opencode.nvim` 插件与 OpenCode AI 助手进行高效交互。本配置已从旧版的 `nickjvandyke/opencode.nvim` 迁移。

## 1. 插件来源与要求

- **插件库**: [sudo-tee/opencode.nvim](https://github.com/sudo-tee/opencode.nvim)
- **CLI 版本**: 需要安装 `opencode` CLI v0.6.3 或更高版本。
- **管理器**: 使用 `lazy.nvim` 进行插件声明，版本由 Nix flake 统一管理。

## 2. 当前 setup() 配置说明

配置位于 `lua/plugins/util/opencode.lua`，核心选项如下：

- `default_global_keymaps = false`: 禁用插件内置的全局键位，改为在 `lua/config/keymaps/opencode.lua` 中统一管理。
- `default_mode = "build"`: 默认使用构建模式，更倾向于直接修改代码而非仅仅对话。
- **UI 配置**:
  - `position = "right"`: AI 面板显示在编辑器右侧。
  - `window_width = 0.40`: 占据 40% 的窗口宽度。
  - `icons.preset = "nerdfonts"`: 使用 Nerd Fonts 图标。
- **Context 系统**:
  - `enabled = true`: 启用上下文自动注入。
  - `current_file`: 自动包含当前正在编辑的文件（enabled=true, show_full_path=true）。
  - `selection`: 自动包含当前视觉选择的代码块。
  - `diagnostics`: 自动包含当前文件的警告和错误诊断信息。
- `vim.o.autoread = true`: AI 修改文件后，Neovim 会自动重新加载对应的 buffer。

## 3. 快捷键速查表

以下快捷键在 `lua/config/keymaps/opencode.lua` 中定义：

| 快捷键 | 模式 | 描述 |
| :--- | :--- | :--- |
| `<leader>ot` | n | 切换 OpenCode 面板显示/隐藏 |
| `<leader>og` | n | 在 OpenCode 窗口与上一个窗口间切换焦点 |
| `<leader>oq` | n | 关闭 OpenCode 面板 |
| `<leader>oi` | n | 打开输入窗口（当前 Session） |
| `<leader>oa` | n | 打开输入窗口（新 Session） |
| `<leader>os` | n | 选择/搜索历史 Session |
| `<leader>oT` | n | 查看 Session 时间线 |
| `<leader>op` | n | 配置 Provider/模型 |
| `<leader>od` | n | 打开 Diff 视图查看 AI 改动 |
| `<leader>ou` | n | 撤销上一次 Prompt 产生的改动 |
| `<leader>oU` | n | 撤销当前 Session 产生的所有改动 |
| `<leader>o/` | n, x | 快速对话（Quick Chat） |

*注：在任意 Snacks picker 中按 `<A-a>` 可将选中的文件发送至 OpenCode。*

## 4. 窗口内快捷键

这些快捷键在 OpenCode 输入或输出窗口中生效，由插件原生提供：

- `<Tab>`: 触发 Context 选择器（文件、Mention 等）。
- `<Enter>`: 发送消息（在输入框中）。
- `<Esc>`: 退出输入模式或关闭悬浮窗。
- `<S-Enter>`: 在输入框中换行（非发送）。

## 5. Context 系统

OpenCode 允许通过特殊字符动态添加上下文：

- `@`: Mention 特定对象（如当前 Buffer、诊断信息、Git 状态等）。
- `~`: 触发文件选择器，手动添加特定文件到上下文。
- `/`: 执行斜杠命令（如 `/clear` 清空当前 Session）。
- `#`: 快速引用预定义的 Context 选项。

## 6. Diff/Revert 工作流

当 AI 生成代码改动时，可以使用以下流程：

1. **查看改动**: 使用 `<leader>od` 打开 Diff 分栏，对比 AI 建议与当前代码。
2. **局部回滚**: 若对最近一次生成不满意，使用 `<leader>ou` 撤销该次 Prompt 的所有改动。
3. **全额回滚**: 若需要放弃整个 Session 的改动，使用 `<leader>oU`。

## 7. Session 管理

- **持久化**: 所有 Session 会自动保存，即便重启 Neovim 也能继续对话。
- **切换**: 使用 `<leader>os` 可以在历史对话间快速切换。
- **追溯**: 使用 `<leader>oT` 查看当前 Session 的演进过程。
- **新建**: 使用 `<leader>oa` 随时开启全新的任务上下文。
