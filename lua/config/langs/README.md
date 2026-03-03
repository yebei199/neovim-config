# langs — 语言工具链配置

每个文件对应一种编程语言，集中声明该语言的完整工具链配置，由 `lua/config/language.lua` 在对应 filetype 打开时按需加载。

## 设计意图

将语言配置从 conform.nvim、nvim-lspconfig、nvim-treesitter 等各插件的配置文件中解耦出来，统一在单一文件中声明。修改一种语言的支持时只需编辑一个文件，添加新语言只需新建文件，无需同时改动多处插件配置。

## 配置结构

每个语言文件返回一张符合 `Config.LangConfig` 类型的表，包含以下可选字段：

- `lsp` — LSP 服务器名称或含配置选项的表，由 `vim.lsp.config` 应用
- `formatter` — conform.nvim 使用的 formatter 名称（单个或列表）
- `treesitter` — treesitter parser 名称，默认按语言名自动推导
- `pkgs` — Mason 安装包名（当包名与 lsp/formatter 名不一致时显式指定）
- `plugins` — 语言专属的 lazy.nvim 插件 spec，随语言按需加载
- `enabled` — 是否启用此语言配置，默认 true

语言配置支持嵌套，可在一个文件中声明多个相关语言（如 javascript.lua 同时涵盖 TypeScript）。

## 当前支持语言

cpp、python、rust、lua、javascript（含 TypeScript）、nix、markdown、html、fish、haskell、qml、dotfile
