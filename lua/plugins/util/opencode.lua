-- opencode.nvim 插件声明
-- nickjvandyke/opencode.nvim：通过 snacks.terminal 嵌入 opencode TUI，浮动窗口模式
-- server.toggle/start/stop 委托给 snacks.terminal，保持与项目浮动终端风格一致
-- <leader>o 前缀承接完整键位体系；<C-\> 保留给 toggleterm
local OPENCODE_CMD = "opencode --port"
local FLOAT_WIDTH = 0.80

---@type snacks.terminal.Opts
local terminal_opts = {
  win = {
    position = "float",
    border = "rounded",
    width = FLOAT_WIDTH,
    enter = true,
    on_win = function(win)
      require("opencode.terminal").setup(win.win)
      -- 覆盖插件默认的 <Esc>=interrupt，恢复终端 insert→normal 切换
      -- interrupt 专用键为 <leader>oi（全局已设）
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = win.buf, desc = "Terminal: insert→normal" })
    end,
  },
}

return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      ---@module "snacks"
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(OPENCODE_CMD, terminal_opts)
        end,
        stop = function()
          local t = require("snacks.terminal").get(OPENCODE_CMD, terminal_opts)
          if t then t:close() end
        end,
        toggle = function()
          require("snacks.terminal").toggle(OPENCODE_CMD, terminal_opts)
        end,
      },
    }

    vim.o.autoread = true

    -- toggle：浮动窗口开关（<leader>ot，<C-\> 留给 toggleterm）
    vim.keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end,
      { desc = "Toggle opencode" })

    -- ask：发送当前上下文（@this 占位符）
    vim.keymap.set({ "n", "x" }, "<leader>oa",
      function() require("opencode").ask("@this: ", { submit = true }) end,
      { desc = "Ask opencode" })

    -- select：从 prompts/commands/server 列表选择
    vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end,
      { desc = "Select opencode action" })

    -- operator：将范围/行发送给 opencode
    vim.keymap.set({ "n", "x" }, "go",
      function() return require("opencode").operator("@this ") end,
      { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "goo",
      function() return require("opencode").operator("@this ") .. "_" end,
      { desc = "Add line to opencode", expr = true })

    -- session 滚动
    vim.keymap.set("n", "<S-C-u>",
      function() require("opencode").command("session.half.page.up") end,
      { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<S-C-d>",
      function() require("opencode").command("session.half.page.down") end,
      { desc = "Scroll opencode down" })

    -- session 管理
    vim.keymap.set("n", "<leader>on",
      function() require("opencode").command("session.new") end,
      { desc = "New opencode session" })
    vim.keymap.set("n", "<leader>ol",
      function() require("opencode").command("session.list") end,
      { desc = "List opencode sessions" })
    vim.keymap.set("n", "<leader>oi",
      function() require("opencode").command("session.interrupt") end,
      { desc = "Interrupt opencode" })
  end,
}
