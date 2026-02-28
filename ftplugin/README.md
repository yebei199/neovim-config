# ftplugin — 文件类型触发脚本

本目录遵循 Neovim 原生的 `ftplugin` 机制：当编辑器打开某个 buffer 时，若其 `filetype` 与目录下某个文件名匹配，该文件会被自动 source。命名规则为 `{filetype}.lua`，每个文件只处理单一文件类型的局部配置。相比在 `autocmds` 中按 filetype 注册事件，ftplugin 目录的方式更贴近 Neovim 的内置约定，且无需手动监听 `FileType` 事件。

与 `lua/config/autocmds/` 的区别在于：ftplugin 适合那些不需要与其他模块共享状态、独立完整的单文件类型集成；autocmds 则用于跨 filetype 或需要引用外部模块的通用逻辑。

## 当前文件

**`scrollback.lua`** 提供 Kitty 终端 scrollback pager 的 Neovim 集成。当 Kitty 配置了 `scrollback_pager nvim -c 'set filetype=scrollback'` 时，终端历史输出会以该 filetype 在 Neovim 中打开，此脚本随即自动执行。它通过 `Snacks.terminal.colorize()` 对 ANSI 转义序列进行着色还原，将 buffer 设置为只读（`modifiable = false`），隐藏状态栏（`laststatus = 0`）以减少视觉干扰，并绑定 `q` 和 `i` 两个快捷键直接退出，使终端历史的浏览体验接近专用 pager 工具。

## 扩展方式

若需为其他文件类型添加局部配置，只需在本目录创建对应的 `{filetype}.lua` 文件，无需修改任何现有代码。
