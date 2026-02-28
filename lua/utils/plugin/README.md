# plugin — 插件专属工具库

本目录是 `lua/utils/` 工具库中与具体插件强绑定的子模块，存放那些只有在特定插件存在时才有意义的辅助函数。与 `utils/` 顶层的通用工具（`fn.lua`、`fs.lua` 等）不同，本目录中的每个文件都针对某一具体插件封装常用操作，消除插件配置代码中的样板代码，并将插件的使用细节集中管理。

本目录的文件由 `lua/plugins/` 或 `lua/config/keymaps/` 中的配置代码调用，不主动执行任何副作用，仅暴露函数接口。

## 文件职责

**`mason.lua`** 封装 Mason 包管理器的两个常用操作：`get_path(pkg_name, path)` 根据包名和相对路径拼接出 Mason 安装目录下的绝对路径，`install(pkg_name)` 在包未安装时触发静默安装并通过 `vim.notify` 反馈结果。这两个函数在语言配置（`langs/`）中被调用，避免各语言文件重复处理 Mason 路径计算与安装逻辑。

**`snacks.lua`** 封装 Snacks.nvim 的两个高频操作：`picker(name, opts)` 统一了"内置 picker"与"自定义 picker"（来自 `config/pickers/`）的调用方式，对外提供一致的函数接口并做结果缓存；`word_goto(count, cycle)` 返回一个跳转到相邻同名标识符的闭包，用于快捷键绑定。

**`zk.lua`** 提供 Zk 知识库集成的辅助函数，封装笔记查询与操作的调用细节。

**`heirline/`** 是状态栏组件库子目录，规模较大，独立成子目录管理。
