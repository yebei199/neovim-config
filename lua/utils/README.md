# utils — 工具库

为 config 和 plugins 两层提供通用工具函数和辅助模块，本身不主动执行任何操作，仅暴露函数接口供调用。工具库不依赖 config 或 plugins，保持单向依赖关系。

## 顶层文件

- `fn.lua` — 通用函数式工具（map、filter、reduce、pipe 等高阶函数封装）
- `list.lua` — 列表与集合操作（去重、扁平化、分组、差集等）
- `edit.lua` — 编辑辅助函数（光标操作、文本范围处理等）
- `format.lua` — 格式化相关工具函数（字符串对齐、截断、单位换算等）
- `fs.lua` — 文件系统操作（路径拼接、目录遍历、文件存在性检查等）
- `root.lua` — 项目根目录识别，基于 `.git`、`flake.nix` 等标志文件向上查找
- `profiler.lua` — 启动性能分析工具，测量模块加载耗时
- `plugin.lua` — 插件开发辅助（延迟调用、条件执行等）

## 子目录

**highlight/** — 高亮组管理 API，封装 `vim.api.nvim_set_hl` 的读写操作，支持批量应用高亮配置表。

**language/** — 语言配置解析与应用的核心实现，包含 `Lang`（单语言）和 `Langs`（多语言管理器）两个类，是 `lua/config/language.lua` 的底层支撑。

**plugin/** — 针对具体插件的辅助工具（mason 包名映射、snacks 工具函数、zk 集成、heirline 状态栏组件库）。
