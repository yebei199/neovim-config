-- opencode.nvim 插件声明
-- 将 opencode AI 助手嵌入 Neovim，通过 snacks.nvim 增强输入和选择体验
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
    vim.g.opencode_opts = {}

    -- opencode 编辑文件后自动重载对应 buffer
    vim.o.autoread = true
  end,
}
