-- lua/config/keymaps/test.lua
-- neotest 测试快捷键：运行测试、查看结果、调试测试

local map = vim.keymap.set
local nt = function() return require("neotest") end

map("n", "<leader>tr", function() nt().run.run() end, { desc = "Run Nearest Test" })
map("n", "<leader>tf", function() nt().run.run(vim.fn.expand "%") end, { desc = "Run File" })
map("n", "<leader>ts", function() nt().summary.toggle() end, { desc = "Toggle Summary" })
map("n", "<leader>to", function() nt().output.open({ enter = true }) end, { desc = "Show Output" })
map("n", "<leader>td", function() nt().run.run({ strategy = "dap" }) end, { desc = "Debug Nearest" })
map("n", "<leader>tS", function() nt().run.stop() end, { desc = "Stop" })
