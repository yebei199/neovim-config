-- lua/plugins/lsp/test.lua
-- neotest 测试框架 UI：在编辑器内运行测试、查看结果、集成调试
-- 适配器（如 rustaceanvim.neotest）通过各语言 langs/*.lua 在 config 中注册

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = true,
    opts = {
      adapters = {},
      output = { open_on_run = true },
      status = { virtual_text = true },
    },
  },
}
