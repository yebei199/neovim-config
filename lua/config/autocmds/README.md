# autocmds — 自动命令

集中存放所有 Neovim 自动命令（autocommand）定义，事件处理逻辑不散落在其他模块中，便于整体审查和管理。

## 文件

- `init.lua` — 模块入口，创建统一的 augroup 并加载各子模块的自动命令
- `quit_filetypes.lua` — 为帮助文档、quickfix、oil 等临时性缓冲区注册 `q` 快速关闭映射，避免为每个 filetype 单独在 ftplugin 中重复配置

## 设计意图

将自动命令集中在独立目录而非分散写入各插件配置回调，使事件驱动行为的全局视图清晰可查。新增自动命令时统一在此处添加，不污染 options、keymaps 等其他初始化文件。所有命令归属同一 augroup，方便在需要时批量清除或重新注册。
