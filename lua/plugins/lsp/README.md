# lsp — 语言服务器与智能编辑插件

LSP 生态的插件层，提供智能编辑功能的框架和 UI。各语言具体使用哪个服务器、如何配置，定义在 `lua/config/langs/` 而非此处，实现框架与语言配置的分离。

## 文件

- `mason.lua` — LSP 服务器、formatter、linter 等工具的自动安装与版本管理，语言配置中声明的工具名由 mason 负责下载安装
- `treesitter.lua` — 语法树解析基础设施，为高亮、折叠、文本对象、缩进等功能提供准确的语法结构支撑。主 `nvim-treesitter` 插件统一负责 `setup` 与 parser 安装列表装配，`nvim-treesitter-textobjects` 作为扩展依赖挂载，只提供文本对象能力而不再单独承担初始化职责，这样可以避免入口模块名变化或 lazy 加载顺序差异造成启动期报错。parser 列表仍然来自 `lua/config/language.lua` 汇总后的语言声明，保持语言工具链入口集中、行为边界清晰。
- `complete.lua` — 自动补全引擎配置，整合 LSP 补全、snippet、路径、buffer 等来源，SQL filetype 额外注册 vim-dadbod-completion 作为字段补全源，定义补全菜单的外观和触发行为
- `diagnostic.lua` — 诊断信息的展示方式配置，包括行内虚拟文本、浮动窗口、符号栏图标的样式与更新策略
- `format.lua` — conform.nvim 的配置，管理保存时自动格式化和手动格式化的触发逻辑，formatter 由语言配置声明
- `todo.lua` — 识别并高亮代码中的 TODO/FIXME/HACK 等注释标记，提供列表视图和跳转导航
- `trouble.lua` — 诊断信息、LSP 引用、quickfix 等的统一汇总窗口，提供比默认 quickfix 更好的浏览和过滤体验
