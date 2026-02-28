# queries/lua — Lua 语言 TreeSitter 查询

本目录为 Lua 语言提供自定义 TreeSitter 高亮查询，专门针对 Neovim 配置代码的编写场景进行优化。

## 文件职责

**`highlights.scm`** 以 `;;extends` 声明模式追加在内置 Lua 高亮规则之上。当前包含一条规则：将名称等于 `vim` 的标识符节点标记为 `@namespace.builtin` 高亮分组。

这条规则的背景是：标准 Lua TreeSitter 解析器将 `vim` 视为普通的全局变量标识符，不赋予任何特殊语义。但在 Neovim 配置代码中，`vim` 是核心 API 对象，其下挂载了 `vim.api`、`vim.fn`、`vim.opt` 等命名空间。将其标记为内置命名空间后，主流配色方案（如 tokyonight、catppuccin）会将 `vim` 渲染成与普通变量不同的颜色，使其在代码中视觉上更突出，降低阅读配置文件时的认知成本。

## 查询机制说明

`;;extends` 指令告知 Neovim 不替换内置的 Lua 高亮查询，而是在其基础上追加本文件中的规则。这意味着内置的关键字、字符串、函数等高亮规则不受影响，本目录只做增量定制。若要完全替换某语言的高亮逻辑，去掉 `;;extends` 即可，但这会导致所有内置规则失效，通常不推荐。
