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