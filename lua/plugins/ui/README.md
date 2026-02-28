# ui — 界面与主题插件

控制编辑器整体视觉层的插件集合，负责配色、状态栏、标签栏、通知等视觉元素的统一管理。与 editor 和 lsp 层分离，视觉调整不影响编辑功能。

## 文件

- `colorscheme.lua` — 配色方案加载与切换，在 colorscheme 应用后触发 `highlight.lua` 中定义的覆盖规则，确保自定义高亮在主题切换后持久生效
- `heirline.lua` — 基于 heirline 的状态栏和标签栏配置，引用 `lua/utils/plugin/heirline/` 中的组件库，实现模式指示、文件信息、LSP 诊断、Git 状态、时间等信息的模块化组合
- `highlight-color.lua` — 在代码中内联预览颜色值，识别 `#rrggbb`、`rgb()`、CSS 颜色名等格式并在背景或前景渲染对应色块，前端开发时尤为实用
- `snacks.lua` — 通知系统配置，将 `vim.notify` 替换为现代化的浮动通知，支持进度条、历史记录查看
- `tabline.lua` — 标签页（tab）而非缓冲区列表的标签栏，配合 grapple 等工具管理当前工作上下文，避免 bufferline 式的缓冲区堆积
