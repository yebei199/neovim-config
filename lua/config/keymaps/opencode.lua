-- opencode.nvim 快捷键（sudo-tee/opencode.nvim）
-- <leader>o 前缀作为 opencode AI 助手的统一交互入口
-- 全局键在此文件管理；窗口内快捷键（<tab>/<esc>/<S-CR>等）在 setup() 中配置
local map = vim.keymap.set
local api = function() return require("opencode.api") end

-- 面板控制
map("n", "<leader>ot", function() api().toggle() end, { desc = "Toggle opencode" })
map("n", "<leader>og", function() api().toggle_focus() end, { desc = "Focus opencode / last window" })
map("n", "<leader>oq", function() api().close() end, { desc = "Close opencode" })

-- 输入窗口
map("n", "<leader>oi", function() api().open_input() end, { desc = "Open input (current session)" })
map("n", "<leader>oa", function() api().open_input_new_session() end, { desc = "Open input (new session)" })

-- Session 管理
map("n", "<leader>os", function() api().select_session() end, { desc = "Select session" })
map("n", "<leader>oT", function() api().timeline() end, { desc = "Session timeline" })

-- Provider/Model 切换
map("n", "<leader>op", function() api().configure_provider() end, { desc = "Configure provider/model" })

-- Diff 与回滚
map("n", "<leader>od", function() api().diff_open() end, { desc = "Diff: view AI changes" })
map("n", "<leader>ou", function() api().diff_revert_all_last_prompt() end, { desc = "Revert last prompt changes" })
map("n", "<leader>oU", function() api().diff_revert_all_session() end, { desc = "Revert all session changes" })

-- Quick chat
map({ "n", "x" }, "<leader>o/", function() api().quick_chat() end, { desc = "Quick chat" })
