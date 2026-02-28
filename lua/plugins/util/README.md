# util — 工具类插件

不直接参与代码编辑，但优化整体工作流和开发体验的辅助插件集合。

## 文件

- `flatten.lua` — 拦截嵌套 Neovim 实例（如在终端中打开 `git commit` 编辑器时），将其重定向到外层已有的 Neovim 实例，避免 Neovim-in-Neovim 问题
- `grapple.lua` — 文件书签与快速跳转，为当前项目中频繁访问的文件打标签，实现即时切换，比 harpoon 更轻量的同类方案
- `lazydev.lua` — Neovim 配置开发支持，为 `vim.*` API 和插件类型提供 LuaLS 类型提示，使编写配置文件时有完整的补全和类型检查
- `noice.lua` — 重构命令行、消息、搜索提示等内置 UI，将其替换为现代化的浮动窗口形式，改善高频交互的视觉体验
- `overseer.lua` — 异步任务运行器，支持定义、执行和监控构建/测试/自定义脚本任务，结果展示在专用面板中
- `snacks.lua` — folke/snacks.nvim 的通用小工具配置，提供 dashboard、input、lazygit 集成等多个独立功能模块
- `whichkey.lua` — 按下 Leader 键后实时展示可用快捷键及其描述，降低快捷键记忆负担，也作为快捷键文档的可视化入口
- `zk.lua` — 与 zk（Zettelkasten 笔记工具）的集成，支持在 Neovim 内创建、搜索、链接知识库笔记
