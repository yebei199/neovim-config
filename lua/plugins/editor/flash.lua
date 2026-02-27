return {
  "folke/flash.nvim",
  event = "LazyFile",
  opts = { modes = { char = { keys = {} } } },
  ---@type Flash.Config
  keys = {
    {
      "f",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
        vim.cmd("normal! zz")
      end,
      desc = "Flash",
    },
    {
      "<C-space>",
      mode = "o",
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function() require("flash").remote() end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function() require("flash").treesitter_search() end,
      desc = "Treesitter Search",
    },
  },
}
