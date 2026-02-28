# plugins — 插件规范与配置

存放所有 lazy.nvim 插件声明，每个 `.lua` 文件返回一个或多个 lazy spec 表。插件版本由 Nix flake 管理（而非 lazy.nvim 自身的 lockfile），实现与系统环境的统一版本控制。

## 子目录划分

**component/** — 文件浏览（oil）、内容选择器（Telescope/Snacks picker）、内置终端，属于与编辑流程直接交互的 UI 组件。

**editor/** — 扩展 Neovim 内建编辑能力的插件：快速跳转（flash）、配对符号管理（surround）、增强文本对象（mini-ai）、自动配对（pair）、行内 Git 差异（gitsign）、项目级搜索替换（grug-far）、替换增强（substitute）、格式转换（coerce）、复制历史（yanky）。

**lsp/** — LSP 生态相关插件：工具安装管理（mason）、语法树解析（treesitter）、自动补全（complete）、诊断显示（diagnostic）、代码格式化（format）、TODO 注释（todo）、诊断汇总窗口（trouble）。具体语言的服务器配置不在此处，而在 `lua/config/langs/`。

**ui/** — 纯视觉层插件：配色方案（colorscheme）、状态栏与标签栏（heirline）、颜色值内联高亮（highlight-color）、通知系统（snacks）、标签栏（tabline）。

**util/** — 工作流辅助插件：窗口扁平化（flatten）、文件标记跳转（grapple）、Neovim 开发支持（lazydev）、命令行重构（noice）、任务运行器（overseer）、小工具集合（snacks）、快捷键提示（whichkey）、知识库管理（zk）。
