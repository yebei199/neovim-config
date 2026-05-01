-- 语法树插件规范：由主 nvim-treesitter 插件统一完成 setup，并将 textobjects 作为扩展依赖挂载，避免入口模块与加载顺序不一致导致启动失败。
local TREESITTER_EVENTS = { "LazyFile", "VeryLazy" }
local INCREMENTAL_SELECTION_KEYS = {
  init_selection = "<C-space>",
  node_incremental = "<C-space>",
  scope_incremental = false,
  node_decremental = "<bs>",
}
local TEXTOBJECTS = {
  swap = {
    enable = true,
    swap_next = {
      [">a"] = "@parameter.inner",
    },
    swap_previous = {
      ["<a"] = "@parameter.inner",
    },
  },
  select = {
    enable = true,
    keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
    },
  },
  move = {
    enable = true,
    goto_next_start = {
      ["]f"] = "@function.outer",
      ["]c"] = "@class.outer",
      ["]a"] = "@parameter.inner",
    },
    goto_next_end = {
      ["]F"] = "@function.outer",
      ["]C"] = "@class.outer",
      ["]A"] = "@parameter.inner",
    },
    goto_previous_start = {
      ["[f"] = "@function.outer",
      ["[c"] = "@class.outer",
      ["[a"] = "@parameter.inner",
    },
    goto_previous_end = {
      ["[F"] = "@function.outer",
      ["[C"] = "@class.outer",
      ["[A"] = "@parameter.inner",
    },
  },
}

local function build_treesitter_opts()
  return {
    ensure_installed = require("config.language").treesitter,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = INCREMENTAL_SELECTION_KEYS,
    },
    textobjects = TEXTOBJECTS,
  }
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = TREESITTER_EVENTS,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection", mode = { "n", "x" } },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts = build_treesitter_opts,
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
