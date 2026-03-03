-- Rust 语言工具链与插件配置：rust-analyzer LSP、rustfmt 格式化、rustaceanvim 增强、crates.nvim 依赖管理、neotest 测试集成

return {
  treesitter = true,
  lsp = "rust_analyzer",
  formatter = "rustfmt",
  pkgs = { "rust-analyzer", "rustfmt" },
  plugins = {
    {
      "Saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      opts = {
        completion = { crates = { enabled = true } },
        lsp = { enabled = true, actions = true, completion = true, hover = true },
      },
    },
    {
      "mrcjkb/rustaceanvim",
      ft = { "rust" },
      config = function()
        vim.g.rustaceanvim = {
          server = {
            on_attach = function(_, bufnr)
              vim.keymap.set("n", "<leader>cR", function() vim.cmd.RustLsp "codeAction" end, { desc = "Code Action", buffer = bufnr })
              vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp "debuggables" end, { desc = "Rust Debuggables", buffer = bufnr })
            end,
            default_settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
                checkOnSave = true,
                diagnostics = { enable = true },
                procMacro = {
                  enable = true,
                  ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                  },
                },
                files = {
                  excludeDirs = { ".direnv", ".git", ".github", ".gitlab", "bin", "node_modules", "target", "venv", ".venv" },
                },
              },
            },
          },
        }
      end,
    },
    {
      "nvim-neotest/neotest",
      optional = true,
      opts = function(_, opts)
        opts.adapters = opts.adapters or {}
        table.insert(opts.adapters, require("rustaceanvim.neotest"))
      end,
    },
  },
}
