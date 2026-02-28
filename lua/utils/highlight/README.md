# highlight — 高亮组管理

封装 Neovim 高亮组的读取与设置操作，为 `lua/config/highlight.lua` 和主题相关配置提供统一的 API，避免直接散用 `vim.api.nvim_set_hl` 和 `vim.api.nvim_get_hl`。

## 文件

- `fn.lua` — 核心函数：`get_by_name(name)` 获取高亮组定义，`setter` / `getter` 元表实现链式读写
- `init.lua` — 对外暴露的 `set_highlight(config)` 函数，接受高亮配置表并批量应用；支持 `override`（覆盖现有定义）和 `lingshin`（基于现有颜色派生新高亮）两种应用模式
- `type.lua` — `Config.HighlightTable` 和 `Config.Highlight` 类型定义，供 LuaLS 提供类型提示

## 设计意图

colorscheme 切换后需要重新应用自定义高亮，统一通过此模块中的接口注册覆盖规则，由 `ColorScheme` autocommand 统一重放，保证高亮覆盖的一致性和幂等性。
