-- lua/plugins/util/session.lua
-- 逐项目 session 管理：按 cwd 自动存档和恢复编辑布局。
-- snacks dashboard 的 section = "session" 和 projects section 会自动检测并调用此插件。
-- 不在 nvim 启动时自动恢复（避免打开单文件时干扰），只在从 dashboard 选项目时触发。

return {
  "olimorris/persisted.nvim",
  lazy = true,  -- 按需加载，由 snacks dashboard 触发
  opts = {
    -- 退出时自动存档当前 cwd 的 session
    auto_save = true,
    -- 不在 nvim 启动时自动恢复（只在从 dashboard 显式选择项目时恢复）
    autoload = false,
    -- 按 cwd + git branch 区分 session
    use_git_branch = true,
    -- 不为 dashboard 类 filetype 创建 session
    should_save = function()
      local ft = vim.bo.filetype
      return ft ~= "snacks_dashboard" and ft ~= "alpha"
    end,
  },
}
