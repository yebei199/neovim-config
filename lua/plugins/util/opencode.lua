-- opencode.nvim 插件声明
-- sudo-tee/opencode.nvim：Neovim-native 的 opencode 前端，提供双面板 UI、diff 回滚、session 管理
-- 默认 agent 为 atlas；<leader>o 前缀的完整键位由插件内置 default_global_keymaps 统一管理
-- <C-c> 覆盖修复：绕过 is_running() 的 job_count 误判，直接调用 abort_session
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
    -- 直接调用 abort_session，绕过 is_running() 的 job_count 条件判断
    -- 根因：job_count 仅追踪 HTTP 请求数，AI 推理期间通过 SSE 流式传输不增加 job_count，
    -- 导致 is_running() 在 AI 实际运行时返回 false，cancel() 永远不调用 abort_session
    local function force_abort()
      local state = require('opencode.state')
      if state.active_session and state.api_client then
        pcall(function()
          state.api_client:abort_session(state.active_session.id):wait()
        end)
      end
      if require('opencode.ui.ui').is_opencode_focused() then
        require('opencode.ui.input_window').set_content('')
        require('opencode.ui.ui').focus_input()
      end
    end

    require('opencode').setup({
      -- default_global_keymaps = true 启用完整内置 <leader>o 键位体系
      default_global_keymaps = true,
      default_mode = 'atlas',
      ui = {
        position = 'right',
        window_width = 0.40,
        icons = { preset = 'nerdfonts' },
      },
      context = {
        enabled = true,
        current_file = { enabled = true, show_full_path = true },
        selection = { enabled = true },
        diagnostics = { warn = true, error = true },
      },
      keymap = {
        -- 覆盖默认 <C-c>，在 insert + normal 模式都生效，直接 abort 而不依赖 is_running()
        output_window = {
          ['<C-c>'] = { force_abort, mode = { 'n', 'i' } },
        },
        input_window = {
          ['<C-c>'] = { force_abort, mode = { 'n', 'i' } },
        },
      },
    })
    -- opencode 编辑文件后自动重载对应 buffer
    vim.o.autoread = true
  end,
}
