# statusline — 状态栏组件定义

本目录实现状态栏的各个独立区块组件，每个组件独立成文件，职责单一，最终由 `init.lua` 按布局顺序组装成完整的 Heirline statusline 配置表。颜色通过上层 `heirline/init.lua` 的颜色主题动态注入，组件本身只引用语义颜色名称（如 `green`、`blue`、`red`），不持有具体 hex 值。

## 文件职责

**`mode.lua`** 显示当前编辑模式（Normal / Insert / Visual / Command 等），并根据模式切换状态栏左侧的强调色，颜色映射关系由 `init.lua` 的 `mode_colors` 静态表统一定义。

**`ruler.lua`** 显示光标的行列位置信息，等同于 Vim 的 `%l:%c` ruler，但通过 Heirline 组件方式实现以便统一样式控制。

**`file.lua`** 显示当前文件的路径、修改状态及文件类型图标，聚合了文件相关的多项状态信息。

**`diagnostic.lua`** 汇总 LSP 诊断信息，按 error、warn、info、hint 分级展示各级别的数量，颜色对应 `diag_error`、`diag_warn` 等语义色。

**`diff.lua`** 展示当前文件的 Git diff 统计（新增行数、删除行数、变更行数），颜色对应 `git_added`、`git_removed`、`git_changed`。

**`noice.lua`** 集成 Noice.nvim 的命令行消息状态，在状态栏中显示 Noice 的 lsp progress 或当前命令信息。

**`align.lua`** 和 **`sperator.lua`** 是布局辅助组件，分别提供弹性对齐（`%=`）和视觉分隔符，用于在 `init.lua` 中控制左右区块的分布位置。

**`clock.lua`** 在状态栏右侧显示实时时间。

## 布局组装

`init.lua` 按左到右顺序将组件排列为：`Mode → Diagnostic → File → Align → Noice → Ruler`，并在 `static` 中定义各模式对应的强调色映射，在 `init` 函数中每次渲染时读取当前模式并赋予对应颜色。
