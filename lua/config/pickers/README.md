# pickers — 自定义选择器

定义项目专属的交互式选择器，扩展 Telescope / Snacks 内置选择器无法直接满足的特定需求。

## 文件

- `filetypes.lua` — FileType Picker，枚举所有已通过 `langs/` 配置的编程语言，展示各语言的工具链配置状态（LSP 是否启用、formatter 是否配置等），支持 `<Shift-Enter>` 直接跳转到对应语言的配置文件。通过 `<leader>sf` 触发。

## 设计意图

将自定义选择器独立存放，与 `keymaps/` 中的快捷键绑定、`language.lua` 中的语言数据解耦。选择器只负责呈现和导航，不直接修改配置状态。后续新增的自定义选择器（如 snippet 管理、task 选择等）统一在此目录扩展。
