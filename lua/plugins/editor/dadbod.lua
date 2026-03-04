-- vim-dadbod 数据库工具集成：vim-dadbod-ui 提供侧边栏面板，vim-dadbod 执行 SQL，
-- vim-dadbod-completion 通过 blink.cmp 原生模块提供字段补全（前缀匹配）。
-- 连接凭据从环境变量读取（CLICKHOUSE_URL），存储在 ~/.local/share/db_ui/（不进 Git）。
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  keys = { { "<leader>D", "<cmd>DBUIToggle<cr>", desc = "数据库面板" } },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_win_position = "left"
    -- 从环境变量读取 ClickHouse 连接字符串
    local clickhouse_url = os.getenv("CLICKHOUSE_URL")
    if clickhouse_url then
      vim.g.dbs = {
        { name = "clickhouse", url = clickhouse_url }
      }
    end
  end
}
