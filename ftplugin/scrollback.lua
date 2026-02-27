-- Kitty Scrollback 回溯缓冲区配置
-- 目的: 为 Kitty 终端的 scrollback pager 提供 Neovim 集成
-- 功能:
--   - 对回溯缓冲区进行语法高亮 (Snacks.terminal.colorize)
--   - 禁止编辑模式，保证只读 (modifiable = false)
--   - 隐藏状态栏，简化界面 (laststatus = 0)
--   - 快捷键 'q' 和 'i' 用于快速退出回溯查看器
-- 配置方式: 在 Kitty 配置中设置
--   scrollback_pager nvim -c 'set filetype=scrollback'

Snacks.terminal.colorize()
vim.bo.modifiable = false
vim.o.laststatus = 0
vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = true })
vim.keymap.set("n", "i", "<cmd>q<CR>", { buffer = true })
