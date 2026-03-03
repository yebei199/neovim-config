-- lua/plugins/ui/snacks.lua
-- Snacks.nvim dashboard 配置：首屏以项目列表为主体，右侧展示 GitHub 通知。
-- 左侧：自定义 fn section 展示最近项目（含 tokei 语言占比）+ 快捷键；
-- 右侧（width>135）：gh-notify 终端 + 启动耗时。
-- 项目选择时通过 persisted.nvim 自动恢复该 cwd 的 session。

local DOT_DIR = vim.env.XDG_CONFIG_HOME or "~/.config"
local CONFIG_DIR = vim.fn.stdpath("config")
local PANE2_MIN_COLS = 135  -- 右侧面板出现的最小终端宽度
local PROJECTS_LIMIT = 8    -- 展示的最近项目数

-- 构造右侧面板 section 的通用属性
local function side(opts)
  return vim.tbl_extend("keep", opts, {
    indent = 3,
    padding = 1,
    pane = 2,
    enabled = function() return vim.o.columns > PANE2_MIN_COLS end,
  })
end

local function pick(cmd)
  return function() Snacks.dashboard.pick(cmd) end
end

local function pickfiles(cwd)
  return function() Snacks.dashboard.pick("files", { cwd = cwd }) end
end

-- 构建带 tokei 语言占比的项目列表 items
-- 从 oldfiles 找 git 根目录，缓存的语言数据立即显示，未缓存的后台触发扫描
local function make_project_items()
  local tokei = require("utils.tokei")
  local dirs, seen = {}, {}

  for _, file in ipairs(vim.v.oldfiles) do
    local dir = Snacks.git.get_root(file)
    if dir and not seen[dir] then
      seen[dir] = true
      table.insert(dirs, dir)
      if #dirs >= PROJECTS_LIMIT then break end
    end
  end

  local items = {}
  for i, dir in ipairs(dirs) do
    local name = vim.fn.fnamemodify(dir, ":t")
    local langs = tokei.get_cached(dir)
    local bar = langs and ("  " .. tokei.format_bar(langs)) or ""

    table.insert(items, {
      icon = "  ",
      key = tostring(i),
      desc = name .. bar,
      action = function()
        vim.fn.chdir(dir)
        -- persisted.nvim: 加载该 cwd 的 session
        require("persisted").load({ session = dir })
      end,
    })

    -- 若无缓存则后台扫描（结果写入磁盘，下次打开 dashboard 时生效）
    if not langs then
      tokei.scan(dir, function() end)
    end
  end

  return items
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    dashboard = {
      ---@type snacks.dashboard.Section
      sections = {
        -- 左侧：项目列表（含语言占比）
        {
          title = "Recent Projects",
          icon = " ",
          padding = 1,
          indent = 2,
          make_project_items,
        },
        -- 左侧：快捷操作
        { section = "keys", gap = 1, indent = 2, padding = 1 },
        -- 右侧：GitHub 通知
        side {
          section = "terminal",
          cmd = [[gh notify -san 5 | choose .. -f '#\d+'\033'\[0m\s+' -o '\n   ']],
          height = 10,
          ttl = 5 * 100,
          icon = "",
          title = "Notifications",
        },
        -- 右侧：启动耗时
        side { section = "startup" },
      },
      preset = {
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File",    action = pick("files") },
          { icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent Files", action = pick("oldfiles") },
          { icon = " ", key = ".", desc = "Dot Files",    action = pickfiles(DOT_DIR) },
          { icon = " ", key = "c", desc = "Config",       action = pickfiles(CONFIG_DIR) },
          {
            icon = "󰒲 ",
            key = "l",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
