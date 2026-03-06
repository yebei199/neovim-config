-- opencode.nvim 插件声明
-- nickjvandyke/opencode.nvim：通过 snacks.terminal 嵌入 opencode TUI，浮动窗口模式
-- session 通过 opencode CLI 查询自动恢复：启动时查询匹配当前 cwd 的最近 session；<C-;> 作为 toggle 快捷键
-- server.toggle/start/stop 委托给 snacks.terminal；<C-\> 保留给 toggleterm
local FLOAT_WIDTH = 0.80

-- 构造启动命令：查询 opencode CLI 查找匹配当前 cwd 的最近 session，自动恢复
local function build_cmd()
  local cwd = vim.uv.cwd()
  local json_out = vim.fn.system("opencode session list --format json 2>/dev/null")
  if vim.v.shell_error ~= 0 or json_out == "" then
    return "opencode --port"
  end
  local ok, sessions = pcall(vim.fn.json_decode, json_out)
  if not ok or type(sessions) ~= "table" then
    return "opencode --port"
  end
  -- 查找最近的目录精确匹配 session，CLI 已按 updated DESC 排序
  for _, s in ipairs(sessions) do
    if s.directory == cwd and s.id and s.id ~= "" then
      return "opencode --port -s " .. s.id
    end
  end
  return "opencode --port"
end

---@type snacks.terminal.Opts
local function terminal_opts()
  local cmd = build_cmd()
  return {
    _cmd = cmd, -- snacks 用此字段做 identity key
    win = {
      position = "float",
      border = "rounded",
      width = FLOAT_WIDTH,
      enter = true,
      on_win = function(win)
        -- 不调用 require("opencode.terminal").setup()，避免 TermRequest autocmd
        -- 持有过期 win id 导致 Invalid window id 崩溃
        vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = win.buf, desc = "Terminal: insert→normal" })
      end,
    },
  }
end

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
          local opts = terminal_opts()
          require("snacks.terminal").open(opts._cmd, opts)
        end,
        stop = function()
          -- snacks.terminal.get 需要与 open/toggle 使用同一 cmd 字符串
          local opts = terminal_opts()
          local t = require("snacks.terminal").get(opts._cmd, opts)
          if t then t:close() end
        end,
        toggle = function()
          local opts = terminal_opts()
          require("snacks.terminal").toggle(opts._cmd, opts)
        end,
      },
      events = { enabled = true },
    }

    vim.o.autoread = true

    -- toggle：<C-'> 开关浮动窗口（<C-\> 保留给 toggleterm）
    vim.keymap.set({ "n", "t" }, "<C-'>", function() require("opencode").toggle() end,
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
