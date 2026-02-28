# language — 语言配置解析与应用

语言工具链管理的核心实现层，负责解析 `langs/` 目录下的配置文件并将其应用到 LSP、treesitter、formatter 等系统。`lua/config/language.lua` 调用本模块完成实际工作。

## 文件

- `init.lua` — `setup()` 入口，扫描 `langs/` 目录加载所有语言配置文件，初始化 `Langs` 实例并注册 filetype 事件触发器
- `langs.lua` — `Langs` 类，多语言统一管理器：`collect()` 聚合所有语言的特定配置项（如全部 formatter 名称）、`config()` 批量应用 LSP 配置、`solve()` 解析嵌套配置的依赖关系
- `lang.lua` — `Lang` 类，单语言配置处理器：`set_treesitter()` 注册 parser、`set_formatter()` 向 conform 注册 formatter、`config_lsp()` 调用 `vim.lsp.config`、`get_lspnames()` 提取服务器名用于 mason 安装
- `fn.lua` — 工具函数：`get_names()` 从配置表递归提取语言名、`get_path()` 构造配置文件路径、`diagnostic_goto()` 生成带严重级别过滤的诊断跳转函数
- `type.lua` — `Config.LangConfig`、`Config.Lang`、`Config.Langs` 类型定义

## 关键设计

支持配置嵌套：一个语言文件可声明数组形式的子语言配置，`solve()` 在应用前递归展平依赖链，使 JavaScript 和 TypeScript 等相关语言可共享配置而无需重复定义。
