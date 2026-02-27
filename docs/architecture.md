# 项目架构

## 概述

这是一个模块化的 Neovim 配置项目，使用 lazy.nvim 作为插件管理器，实现集中式语言配置管理。

## 核心结构

### 配置层 (`lua/config/`)
- `options.lua`: Neovim 基础选项
- `lazy.lua`: 插件管理器配置
- `keymaps/`: 键映射配置
- `autocmds/`: 自动命令
- `highlight.lua`: 语法高亮
- `neovide.lua`: Neovide GUI 配置
- `language.lua`: 语言配置入口
- `langs/`: 各语言特定配置
- `pickers/`: 文件类型选择器

### 插件层 (`lua/plugins/`)
按功能分类组织：
- `component/`: 核心组件 (oil, picker, terminal)
- `ui/`: 用户界面 (tabline, colorscheme, heirline)
- `lsp/`: 语言服务器协议 (treesitter, mason, diagnostic)
- `util/`: 实用工具 (whichkey, snacks, noice)
- `editor/`: 编辑器增强 (flash, surround, gitsign)

### 工具层 (`lua/utils/`)
- `fn.lua`: 通用函数
- `language/`: 语言配置工具
- `highlight/`: 高亮工具
- `plugin/`: 插件相关工具
- `root.lua`: 项目根目录检测
- `fs.lua`: 文件系统操作

### Nix 配置层 (nix/)

使用 home-manager 模块系统实现配置模块化：

#### Rust 工具链配置 (nix/rust.nix)
- 完整的 home-manager 模块，提供 Rust 工具链和环境变量
- 工具链：通过 rust-overlay 获取最新稳定版 Rust，包含 rustfmt、clippy、rust-src、rust-analyzer
- 目标：支持 x86_64-unknown-linux-musl 交叉编译
- 环境变量：清华镜像（RUSTUP_DIST_SERVER、RUSTUP_UPDATE_ROOT）和 SCCACHE 缓存配置

#### Neovim 配置 (nix/neovim.nix)
- 完整的 home-manager 模块，集中管理 Neovim 编辑器和工具配置
- Packages：开发工具（gnumake、ripgrep、neovide）、Web 开发工具（biome、tailwindcss、prettier）、语言服务器
- 配置文件：将项目根目录递归链接到 ~/.config/nvim，实现配置文件统一管理
- 编辑器设置：启用 Neovim，设置为系统默认编辑器

#### 集成方式
在 flake.nix 的 homeModules.nvim-config 列表中导入所有模块：`[./nix/rust.nix, ./nix/neovim.nix]`。home-manager 会自动合并所有 home.packages、home.sessionVariables 和其他配置。

## 语言配置系统

实现集中式管理：
- LSP 服务器配置
- Treesitter 解析器
- 代码格式化器
- Mason 包管理
- 语言特定插件

支持嵌套配置，方便多语言项目管理。

## 启动流程

1. `init.lua` 加载基础选项和插件管理器
2. Lazy 按类别加载插件配置
3. 延迟加载键映射、自动命令和高亮
4. 初始化语言配置系统
5. 应用颜色方案 (tokyonight)