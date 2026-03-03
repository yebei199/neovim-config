-- lua/utils/tokei.lua
-- tokei 语言统计工具：异步扫描项目目录，磁盘缓存结果，供 dashboard fn section 调用。
-- 缓存路径：stdpath("data")/tokei_cache.json，TTL 6 小时。
-- 首次打开 dashboard 时触发后台扫描，后续打开直接读缓存（几乎零延迟）。

local M = {}

local CACHE_PATH = vim.fn.stdpath("data") .. "/tokei_cache.json"
local CACHE_TTL = 6 * 3600  -- 6 小时（秒）
local TOP_LANGS = 3          -- 最多显示语言数
local BAR_WIDTH = 8          -- 进度条字符宽度

-- 从磁盘加载缓存，失败返回空表
local function load_cache()
  local f = io.open(CACHE_PATH, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  local ok, data = pcall(vim.fn.json_decode, content)
  return (ok and type(data) == "table") and data or {}
end

-- 将缓存写入磁盘
local function save_cache(cache)
  vim.fn.mkdir(vim.fn.fnamemodify(CACHE_PATH, ":h"), "p")
  local f = io.open(CACHE_PATH, "w")
  if not f then return end
  f:write(vim.fn.json_encode(cache))
  f:close()
end

-- 检查缓存条目是否仍在 TTL 内
local function is_valid(entry)
  return entry and entry.ts and (os.time() - entry.ts) < CACHE_TTL
end

-- 解析 tokei JSON 输出，返回 {{lang, pct}, ...} 按占比降序排列
-- 失败返回 nil
local function parse_tokei(json_str)
  local ok, data = pcall(vim.fn.json_decode, json_str)
  if not ok or type(data) ~= "table" then return nil end

  local total, langs = 0, {}
  for lang, info in pairs(data) do
    if type(info) == "table" and type(info.code) == "number" and info.code > 0 then
      langs[lang] = info.code
      total = total + info.code
    end
  end
  if total == 0 then return nil end

  local sorted = {}
  for lang, lines in pairs(langs) do
    table.insert(sorted, { lang = lang, pct = math.floor(lines / total * 100 + 0.5) })
  end
  table.sort(sorted, function(a, b) return a.pct > b.pct end)

  local result = {}
  for i = 1, math.min(TOP_LANGS, #sorted) do
    result[i] = sorted[i]
  end
  return result
end

-- 异步扫描目录，完成后调用 cb(langs)，失败调用 cb(nil)
-- langs: {{lang: string, pct: number}, ...}
function M.scan(path, cb)
  vim.system(
    { "tokei", "--sort", "lines", "--output", "json", path },
    { text = true, timeout = 15000 },
    function(result)
      if result.code ~= 0 then
        vim.schedule(function() cb(nil) end)
        return
      end
      local langs = parse_tokei(result.stdout)
      vim.schedule(function()
        if langs then
          local cache = load_cache()
          cache[path] = { ts = os.time(), langs = langs }
          save_cache(cache)
        end
        cb(langs)
      end)
    end
  )
end

-- 读取 path 的缓存条目（仅当 TTL 内有效时返回），否则返回 nil
-- 不触发后台扫描，调用方需自行决定是否调用 scan()
function M.get_cached(path)
  local entry = load_cache()[path]
  return is_valid(entry) and entry.langs or nil
end

-- 将语言列表格式化为显示字符串
-- 示例输出："▓▓▓▓▓▓░░ Lua 87% Nix 13%"
function M.format_bar(langs)
  if not langs or #langs == 0 then return "" end

  local bar, labels, filled = {}, {}, 0
  for _, item in ipairs(langs) do
    local blocks = math.max(0, math.min(
      math.floor(item.pct / 100 * BAR_WIDTH + 0.5),
      BAR_WIDTH - filled
    ))
    for _ = 1, blocks do table.insert(bar, "▓") end
    filled = filled + blocks
    table.insert(labels, item.lang .. " " .. item.pct .. "%")
  end
  for _ = 1, BAR_WIDTH - filled do table.insert(bar, "░") end

  return table.concat(bar) .. "  " .. table.concat(labels, " ")
end

return M
