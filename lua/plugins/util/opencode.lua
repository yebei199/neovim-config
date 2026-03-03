-- opencode.nvim 插件声明
-- sudo-tee/opencode.nvim：Neovim-native 的 opencode 前端，提供双面板 UI、diff 回滚、session 管理
-- 默认 agent 为 atlas；<leader>o 前缀的完整键位由插件内置 default_global_keymaps 统一管理
return {
  "sudo-tee/opencode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      optional = true,
    },
    {
      ---@module "snacks"
      "folke/snacks.nvim",
      optional = true,
      opts = {
        picker = {
          actions = {
            -- 在 picker 中按 <A-a> 可将条目发送给 opencode
            opencode_send = function(picker)
              local selected = picker:selected({ fallback = true })
              if not selected or #selected == 0 then return end
              local files = {}
              for _, item in ipairs(selected) do
                if item.file then table.insert(files, item.file) end
              end
              picker:close()
              require("opencode.core").open({ new_session = false, focus = "input", start_insert = true })
              local context = require("opencode.context")
              for _, file in ipairs(files) do
                context.add_file(file)
              end
            end,
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
    require("opencode").setup({
      -- default_global_keymaps = true 启用完整内置 <leader>o 键位体系
      default_global_keymaps = true,
      default_mode = "atlas",
      ui = {
        position = "right",
        window_width = 0.40,
        icons = { preset = "nerdfonts" },
      },
      context = {
        enabled = true,
        current_file = { enabled = true, show_full_path = true },
        selection = { enabled = true },
        diagnostics = { warn = true, error = true },
      },
    })
    -- opencode 编辑文件后自动重载对应 buffer
    vim.o.autoread = true
  end,
}
