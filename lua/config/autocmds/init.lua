local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name) return vim.api.nvim_create_augroup("lingshin_" .. name, { clear = true }) end

-- Debounce timers for per-buffer formatting
local debounce_timers = {}

---防抖格式化：3秒后执行，多次修改只触发一次
local function setup_debounce_format(bufnr)
  -- 取消已存在的 timer
  if debounce_timers[bufnr] then
    vim.fn.timer_stop(debounce_timers[bufnr])
  end

  -- 创建新的 3 秒 timer
  debounce_timers[bufnr] = vim.fn.timer_start(3000, function()
    -- 确保缓冲区仍有效且自动格式化启用
    if vim.api.nvim_buf_is_valid(bufnr) and vim.g.autoformat and vim.b[bufnr].autoformat ~= false then
      pcall(require("conform").format, { bufnr = bufnr, async = true })
    end
    debounce_timers[bufnr] = nil
  end, { ["repeat"] = 1 })
end

---清理缓冲区的 timer
local function cleanup_debounce_timer(bufnr)
  if debounce_timers[bufnr] then
    vim.fn.timer_stop(debounce_timers[bufnr])
    debounce_timers[bufnr] = nil
  end
end
-- Auto Chdir
autocmd({ "BufEnter", "BufWinEnter" }, {
  desc = "Auto change dir to root",
  nested = true,
  callback = function()
    if vim.bo.buftype ~= "" then return end
    vim.fn.chdir(require("utils.root").get())
  end,
})

-- Debounced Auto Format on modification (TextChanged)
autocmd({ "TextChanged", "TextChangedI" }, {
  desc = "Debounced auto format (3s)",
  callback = function(args)
    setup_debounce_format(args.buf)
  end,
})

-- Cleanup debounce timer on buffer unload
autocmd("BufUnload", {
  desc = "Cleanup debounce timer",
  callback = function(args)
    cleanup_debounce_timer(args.buf)
  end,
})

-- Final format on save to ensure disk consistency
autocmd("BufWritePre", {
  desc = "Final format on save",
  callback = function(args)
    if vim.g.autoformat and vim.b.autoformat ~= false then
      -- 同步执行，确保保存前格式化完成
      pcall(require("conform").format, { bufnr = args.buf, async = false })
    end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = augroup "highlight_yank",
  callback = function() vim.highlight.on_yank() end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd("BufWritePre", {
  desc = "Auto Mkdir",
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- close some filetypes with <q>
autocmd("FileType", {
  desc = "Create keymap 'q'",
  pattern = require "config.autocmds.quit_filetypes",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd "close"
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- resize splits if window got resized
autocmd("VimResized", {
  group = augroup "resize_splits",
  callback = function()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. vim.fn.tabpagenr())
  end,
})
