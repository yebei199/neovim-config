# neovim-config

基于 Nix + lazy.nvim 的模块化 Neovim 配置。Neovim 插件版本通过 Nix flake 及 flake.lock 锁定，依赖由 Nix 统一声明保证环境可复现。lazy.nvim 插件管理器不再由 flake 管理，通过 activation script 首次 clone 后自我更新。语言工具链（LSP、formatter、treesitter、语言专属插件）集中在单一文件中配置，避免跨多个插件配置文件分散管理的痛点。

## 顶层目录结构

- `lua/` — 配置主体，分 config（初始化）、plugins（插件声明）、utils（工具库）三层
- `langs/` — 各编程语言的工具链配置，每个文件独立声明一种语言的完整支持
- `nix/` — Nix 环境声明文件，由根目录 `flake.nix` 引入，管理插件和系统级依赖
- `ftplugin/` — 文件类型触发脚本，Neovim 按 filetype 自动加载
- `queries/` — 自定义 TreeSitter `.scm` 查询，扩展或覆盖内置高亮规则
- `docs/` — 架构设计文档与功能开发规划

## 核心设计决策

插件版本管理交给 Nix flake，而非 lazy.nvim 的 lockfile，使版本控制与系统配置统一。语言配置采用统一入口（`lua/config/language.lua`），按 filetype 事件按需加载，启动时不做多余初始化。
