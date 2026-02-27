# config - 核心配置与初始化

本目录包含Neovim的核心配置、选项初始化和事件处理定义。这是Neovim启动和运行的基础，决定了编辑器的基本行为、快捷键、语言支持等。

## 目录结构

### 顶级配置文件

- **lazy.lua** - lazy.nvim插件管理器的初始化和配置
- **options.lua** - Neovim全局选项设置（行号、制表符、搜索等）
- **highlight.lua** - 自定义高亮配置
- **icons.lua** - 图标定义（用于UI中的符号显示）
- **language.lua** - 语言配置系统的核心逻辑
- **neovide.lua** - Neovide GUI客户端的特定配置

### 子目录

#### autocmds/ - 自动命令
定义Neovim事件处理规则，包括：
- 文件保存、读取时的自动操作
- 文件类型识别和初始化
- 编辑器退出时的清理工作
- 其他自动化行为

#### keymaps/ - 快捷键映射
按功能分类的快捷键定义：
- **file.lua** - 文件操作相关快捷键
- **git.lua** - Git集成的快捷键
- **lsp.lua** - LSP相关操作的快捷键
- **search.lua** - 搜索和查找功能的快捷键
- **debug.lua** - 调试相关快捷键
- **toggle.lua** - 功能开关的快捷键
- **winbuf.lua** - 窗口和缓冲区管理的快捷键
- **abbr.lua** - 文本缩写和自动替换

#### langs/ - 语言配置
为每种编程语言提供特定配置，与根目录 `/langs` 目录配合使用。每个文件配置该语言的：
- LSP服务器
- 代码格式化工具
- Treesitter解析器
- 特定的插件和工具

#### pickers/ - 选择器配置
定义Telescope等选择器的配置和自定义选择器实现。

## 配置流程

Neovim启动时的配置加载顺序：
1. options.lua - 设置基础选项
2. lazy.lua - 初始化插件管理器
3. 其他核心配置
4. autocmds/ - 注册事件处理
5. keymaps/ - 绑定快捷键
6. langs/ - 加载语言支持

这种结构保证了配置的正确初始化顺序，避免依赖问题。
