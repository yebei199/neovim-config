-- lazy.nvim 插件管理器初始化与配置
-- 首次启动自动 clone；后续由 lazy.nvim 自身管理更新
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy.core.handler.event").mappings.LazyFile = {
  id = "LazyFile",
  event = { "BufReadPre", "BufNewFile", "BufWritePre" },
}

require("lazy").setup {
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, frequence = 24 * 60 * 60 },
  change_detection = { enabled = false },
  rocks = { enabled = false },
  spec = {
    { import = "plugins.component" },
    { import = "plugins.ui" },
    { import = "plugins.lsp" },
    { import = "plugins.util" },
    { import = "plugins.editor" },

    require("config.language").plugins,
  },
  ui = {
    custom_keys = {
      gf = {
        function(plugins)
          vim.api.nvim_win_close(0, false)
          Snacks.picker.files { cwd = plugins.dir }
        end,
        desc = "Search Files",
      },
    },
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

vim.cmd.colorscheme "tokyonight"
