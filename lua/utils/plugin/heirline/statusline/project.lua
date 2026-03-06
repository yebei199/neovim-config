-- 项目名称组件：显示当前项目的根目录名称
-- 通过 LSP root_dir 或项目文件模式（如 .git）自动检测项目根目录
-- 若未能检测到项目根，则不显示该组件

local root = require "utils.root"
local fs = require "utils.fs"

return {
  provider = function()
    local project_root = root.get()
    if not project_root or project_root == "" then return "" end
    
    local project_name = vim.fn.fnamemodify(project_root, ":t")
    return " " .. project_name
  end,
  hl = { fg = "cyan", bold = true },
  condition = function()
    local project_root = root.get()
    -- 只在非空项目路径下显示，避免在 cwd 等临时场景显示
    return project_root and project_root ~= "" and vim.uv.fs_stat(project_root)
  end,
  update = { "BufEnter", "DirChanged" },
}
