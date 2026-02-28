# heirline — 状态栏组件库

本目录封装 Heirline 插件的全部配置逻辑，包括颜色主题的动态提取机制和各状态栏组件的组装导出。之所以将 Heirline 配置放在 `utils/plugin/` 下而非直接写在 `plugins/ui/heirline.lua` 中，是因为状态栏由多个独立组件构成，每个组件有独立的状态和渲染逻辑，拆分为独立 Lua 模块有助于单独测试和维护；同时颜色主题提取逻辑需要被整个组件树共享，适合作为独立模块集中管理。

## 文件职责

**`init.lua`** 是本目录的唯一出口。它定义 `colors()` 函数，通过 `heirline.utils.get_highlight()` 从当前配色方案的高亮组（Normal、String、Function、DiagnosticError 等语义化高亮组）中动态提取 RGB 颜色值，映射为 `white`、`green`、`blue`、`red` 等语义颜色名称供组件引用。颜色提取在 `ColorScheme` 自动命令中重新执行，保证切换主题后状态栏颜色实时更新，无需重启。`init.lua` 同时导出完整的 statusline 配置表，供 `plugins/ui/heirline.lua` 传递给 Heirline 的 `setup()` 调用。

**`statusline/`** 子目录包含各状态栏区块的独立组件实现，由 `statusline/init.lua` 组装成最终的布局表。

## 颜色设计决策

颜色不硬编码 hex 值，而是从当前高亮组中实时提取。这使状态栏在任意配色方案下都能保持视觉一致性，同时遵循配色方案作者对语义颜色的设计意图。
