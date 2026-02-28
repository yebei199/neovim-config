-- opencode.nvim 快捷键
-- <leader>o 前缀作为 opencode AI 助手的统一交互入口
local map = vim.keymap.set

-- Ask: 注入 @this 上下文并提交
map({ "n", "x" }, "<leader>oa", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode" })

-- Select: 选择预设 prompt 或命令
map({ "n", "x" }, "<leader>os", function()
  require("opencode").select()
end, { desc = "Select opencode action" })

-- Toggle: 显示/隐藏 opencode 面板
map("n", "<leader>ot", function()
  require("opencode").toggle()
end, { desc = "Toggle opencode" })

-- Operator: 把选中范围/当前行加入上下文
map({ "n", "x" }, "<leader>og", function()
  return require("opencode").operator("@this ")
end, { desc = "Add range to opencode", expr = true })

-- Scroll: 在 opencode 面板中滚动
map("n", "<leader>ou", function()
  require("opencode").command("session.half.page.up")
end, { desc = "Scroll opencode up" })

map("n", "<leader>od", function()
  require("opencode").command("session.half.page.down")
end, { desc = "Scroll opencode down" })
