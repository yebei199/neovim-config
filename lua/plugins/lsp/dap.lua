-- lua/plugins/lsp/dap.lua
-- nvim-dap + nvim-dap-ui 配置：调试适配器协议层、UI 界面、codelldb 运行时管理
-- 通过 keymaps/debug.lua 触发加载；codelldb 适配器由 nix/rust.nix 提供

local function find_codelldb()
  -- Try Nix store path first
  local nix_path = vim.fn.glob("/nix/store/*vadimcn.vscode-lldb*/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb")
  if nix_path ~= "" then
    return vim.split(nix_path, "\n")[1]
  end
  -- Fallback to PATH
  local which = vim.fn.exepath("codelldb")
  if which ~= "" then return which end
  -- Last resort: let dap try in PATH, will error at runtime if missing
  return "codelldb"
end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    config = function()
      local dap = require("dap")
      local codelldb_path = find_codelldb()
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    lazy = true,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
}
