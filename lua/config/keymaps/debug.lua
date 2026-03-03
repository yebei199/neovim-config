-- lua/config/keymaps/debug.lua
-- nvim-dap 调试快捷键：启动会话、设置断点、逐步执行、查看状态

local map = vim.keymap.set
local dap = function() return require("dap") end
local dapui = function() return require("dapui") end

map("n", "<leader>db", function() dap().toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function() dap().set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Conditional Breakpoint" })
map("n", "<leader>dc", function() dap().continue() end, { desc = "Continue" })
map("n", "<leader>di", function() dap().step_into() end, { desc = "Step Into" })
map("n", "<leader>do", function() dap().step_out() end, { desc = "Step Out" })
map("n", "<leader>dO", function() dap().step_over() end, { desc = "Step Over" })
map("n", "<leader>dt", function() dap().terminate() end, { desc = "Terminate" })
map("n", "<leader>du", function() dapui().toggle() end, { desc = "Toggle DAP UI" })
map("n", "<leader>de", function() dapui().eval() end, { desc = "Eval Expression" })

-- Visual mode: evaluate selection
map("v", "<leader>de", function() dapui().eval() end, { desc = "Eval Selection" })