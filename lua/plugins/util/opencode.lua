-- opencode.nvim 插件声明
-- 将 opencode AI 助手嵌入 Neovim，通过 snacks.nvim 增强输入和选择体验
-- enter=false 确保面板打开后焦点留在 Neovim；cwd/count 固定确保终端 tid 稳定，避免窗口切换后创建重复终端
return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      ---@module "snacks"
      "folke/snacks.nvim",
      optional = true,
      opts = {
        picker = {
          actions = {
            -- 在 picker 中按 <A-a> 可将条目发送给 opencode
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
    local opencode_cmd = 'opencode --port'
    ---@type snacks.terminal.Opts
    local term_opts = {
      cwd = (vim.uv or vim.loop).cwd(),
      count = 1,
      win = {
        position = 'right',
        enter = false, -- 面板打开时焦点保留在 Neovim，不进入 TUI
        on_win = function(win)
          require('opencode.terminal').setup(win.win)
        end,
      },
    }
    vim.g.opencode_opts = {
      server = {
        start = function()
          require('snacks.terminal').open(opencode_cmd, term_opts)
        end,
        stop = function()
          require('snacks.terminal').get(opencode_cmd, term_opts):close()
        end,
        toggle = function()
          require('snacks.terminal').toggle(opencode_cmd, term_opts)
        end,
      },
    }

    -- opencode 编辑文件后自动重载对应 buffer
    vim.o.autoread = true
  end,
}
