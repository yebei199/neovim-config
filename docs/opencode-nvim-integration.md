# opencode.nvim Integration Research - Complete Guide

**Last Updated:** Feb 28, 2026  
**Latest Release:** v0.4.0 (Feb 20, 2026)  
**Repository:** https://github.com/nickjvandyke/opencode.nvim

---

## 1. OFFICIAL DOCUMENTATION & CONFIGURATION

### 1.1 Primary Configuration Structure: `vim.g.opencode_opts`

The plugin uses a **global configuration table** for simpler UX and faster startup. Configuration is passed via `vim.g.opencode_opts` before the plugin initializes.

**Type Definition** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/config.lua#L14-L37)):

```lua
---@class opencode.Opts
---@field server? opencode.cli.server.Opts
---@field contexts? table<string, fun(context: opencode.Context): string|nil>
---@field prompts? table<string, opencode.Prompt>
---@field ask? opencode.ask.Opts
---@field select? opencode.select.Opts
---@field lsp? opencode.lsp.Opts
---@field events? opencode.events.Opts
```

### 1.2 Complete Default Configuration

All defaults are defined in `lua/opencode/config.lua`:

**Server Configuration** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/config.lua#L45-L56)):
```lua
server = {
  port = nil,  -- Autodetect by default
  start = function()
    require("opencode.terminal").start("opencode --port")
  end,
  stop = function()
    require("opencode.terminal").stop()
  end,
  toggle = function()
    require("opencode.terminal").toggle("opencode --port")
  end,
},
```

**Built-in Contexts** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/config.lua#L58-L68)):
```lua
contexts = {
  ["@this"] = function(context) return context:this() end,
  ["@buffer"] = function(context) return context:buffer() end,
  ["@buffers"] = function(context) return context:buffers() end,
  ["@visible"] = function(context) return context:visible_text() end,
  ["@diagnostics"] = function(context) return context:diagnostics() end,
  ["@quickfix"] = function(context) return context:quickfix() end,
  ["@diff"] = function(context) return context:git_diff() end,
  ["@marks"] = function(context) return context:marks() end,
  ["@grapple"] = function(context) return context:grapple_tags() end,
},
```

**Built-in Prompts** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/config.lua#L69-L80)):
```lua
prompts = {
  ask = { prompt = "", ask = true, submit = true },
  diagnostics = { prompt = "Explain @diagnostics", submit = true },
  diff = { prompt = "Review the following git diff...: @diff", submit = true },
  document = { prompt = "Add comments documenting @this", submit = true },
  explain = { prompt = "Explain @this and its context", submit = true },
  fix = { prompt = "Fix @diagnostics", submit = true },
  implement = { prompt = "Implement @this", submit = true },
  optimize = { prompt = "Optimize @this for performance and readability", submit = true },
  review = { prompt = "Review @this for correctness and readability", submit = true },
  test = { prompt = "Add tests for @this", submit = true },
},
```

**Ask Options** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/config.lua#L81-L123)):
```lua
ask = {
  prompt = "Ask opencode: ",
  completion = "customlist,v:lua.opencode_completion",
  snacks = {
    icon = "󰚩 ",
    win = {
      title_pos = "left",
      relative = "cursor",
      row = -3,  -- Row above cursor
      col = 0,   -- Align with cursor
      keys = {
        i_cr = { desc = "submit" },
        i_s_cr = {
          "<S-CR>",
          function(win)
            local text = win:text() .. "\\n"
            vim.api.nvim_buf_set_lines(win.buf, 0, -1, false, { text })
            win:execute("confirm")
          end,
          mode = "i",
          desc = "append",
        },
      },
      footer_keys = { "<CR>", "<S-CR>" },
      b = { completion = true },
      bo = { filetype = "opencode_ask" },
      on_buf = function(win)
        vim.lsp.start(require("opencode.ui.ask.cmp"), { bufnr = win.buf })
      end,
    },
  },
},
```

**Select Options** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/config.lua#L124-L149)):
```lua
select = {
  prompt = "opencode: ",
  sections = {
    prompts = true,
    commands = {
      ["session.new"] = "Start a new session",
      ["session.select"] = "Select a session",
      ["session.share"] = "Share the current session",
      ["session.interrupt"] = "Interrupt the current session",
      ["session.compact"] = "Compact the current session",
      ["session.undo"] = "Undo the last action",
      ["session.redo"] = "Redo the last undone action",
      ["agent.cycle"] = "Cycle the selected agent",
      ["prompt.submit"] = "Submit the current prompt",
      ["prompt.clear"] = "Clear the current prompt",
    },
    server = true,
  },
  snacks = {
    preview = "preview",
    layout = {
      preset = "vscode",
      hidden = {},
    },
  },
},
```

**LSP Options** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/config.lua#L150-L160)):
```lua
lsp = {
  enabled = false,  -- Disabled by default for stability
  filetypes = nil,
  handlers = {
    hover = {
      enabled = true,
      model = nil,
    },
    code_action = { enabled = true },
  },
},
```

**Events Options** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/config.lua#L161-L168)):
```lua
events = {
  enabled = true,
  reload = true,  -- Auto-reload buffers edited by opencode
  permissions = {
    enabled = true,
    idle_delay_ms = 1000,
  },
},
```

---

## 2. LAZY.NVIM INTEGRATION PATTERNS

### 2.1 Standard Setup with snacks.nvim (Recommended)

The official setup ([README.md](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/README.md#lazynvim)):

```lua
{
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- snacks.nvim integration is recommended, but optional
      ---@module "snacks"
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration here
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode…" })

    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })

    vim.keymap.set({ "n", "t" }, "<C-.>", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go",
      function() return require("opencode").operator("@this ") end,
      { desc = "Add range to opencode", expr = true }
    )
    vim.keymap.set("n", "goo",
      function() return require("opencode").operator("@this ") .. "_" end,
      { desc = "Add line to opencode", expr = true }
    )

    vim.keymap.set("n", "<S-C-u>",
      function() require("opencode").command("session.half.page.up") end,
      { desc = "Scroll opencode up" }
    )
    vim.keymap.set("n", "<S-C-d>",
      function() require("opencode").command("session.half.page.down") end,
      { desc = "Scroll opencode down" }
    )

    -- For opinionated keymaps, remap increment/decrement
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}
```

### 2.2 Snacks Picker Integration: The `opencode_send` Action

The snacks picker integration enables **sending search results directly to opencode**.

**Implementation** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/integrations/pickers/snacks.lua#L1-L26)):

```lua
---Send the selected or current `snacks.picker` items to `opencode`,
---Formats items' file and position if possible, otherwise falls back to their text content.
---@param picker snacks.Picker
function M.send(picker)
  local items = vim.tbl_map(function(item)
    return item.file
        -- Prefer just the location if possible, so the LLM can also fetch context
        and require("opencode.context").format(item.file, {
          start_line = item.pos and item.pos[1] or nil,
          start_col = item.pos and item.pos[2] or nil,
          end_line = item.end_pos and item.end_pos[1] or nil,
          end_col = item.end_pos and item.end_pos[2] or nil,
        })
      or item.text
  end, picker:selected({ fallback = true }))

  if #items > 0 then
    require("opencode").prompt(table.concat(items, "\n"))
  end
end
```

**Integration Pattern in lazy.nvim:**

```lua
opts = {
  picker = {
    actions = {
      opencode_send = function(...) 
        return require("opencode").snacks_picker_send(...) 
      end,
    },
    win = {
      input = {
        keys = {
          ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
        },
      },
    },
  },
},
```

This allows pressing `<A-a>` in the picker to send selected items to opencode.

---

## 3. SNACKS.NVIM INTEGRATION DETAILS

### 3.1 Input Integration

snacks.nvim's `input` module enhances the `ask()` function with:
- Rich text input with context highlighting
- Multiline support with `<S-CR>` to append
- In-process LSP for completions

Configuration:
```lua
input = {},  -- Empty dict enables default snacks.input
```

### 3.2 Picker Integration

snacks.nvim's `picker` module enables:
- Browsing search results in a picker UI
- Sending selected items to opencode with custom action
- Preview pane for context

Configuration:
```lua
picker = {
  actions = {
    opencode_send = function(...) 
      return require("opencode").snacks_picker_send(...) 
    end,
  },
  win = {
    input = {
      keys = {
        ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
      },
    },
  },
},
```

---

## 4. NIX/NIXVIM INTEGRATION

### 4.1 nixvim Configuration

From [nixvim docs](https://nix-community.github.io/nixvim/plugins/opencode/index.html):

```nix
programs.nixvim = {
  plugins.opencode = {
    enable = true;
    autoLoad = false;  # false when lazy-loading enabled
    settings = {
      # Maps to vim.g.opencode_opts
      events = {
        reload = true;
      };
      prompts = {
        custom_prompt = {
          prompt = "Your custom prompt here";
          submit = true;
        };
      };
    };
  };
  
  # Required: snacks.nvim for embedded terminal and enhanced input/picker
  plugins.snacks = {
    enable = true;
    settings = {
      input = { enabled = true; };
      picker = { enabled = true; };
    };
  };
  
  # Important: Enable autoread for file reload
  opts = {
    autoread = true;
  };
};
```

**Important Notes for Nix:**
1. `snacks.enable` is **required** for the embedded terminal
2. `snacks.input.enabled = true` is **recommended** for better prompt input
3. Set `opts.autoread = true` when using `events.reload`

---

## 5. FILE RELOAD BEHAVIOR (AUTOREAD)

### 5.1 How It Works

When opencode edits files, the plugin fires an `OpencodeEvent:file.edited` event ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/plugin/events/reload.lua#L1-L23)):

```lua
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("OpencodeReload", { clear = true }),
  pattern = "OpencodeEvent:file.edited",
  callback = function(args)
    if require("opencode.config").opts.events.reload then
      if not vim.o.autoread then
        vim.notify(
          "Please set `vim.o.autoread = true` to use `opencode.nvim` auto-reload",
          vim.log.levels.WARN,
          { title = "opencode" }
        )
      else
        vim.schedule(function()
          vim.cmd("checktime")  -- Checks ALL buffers
        end)
      end
    end
  end,
  desc = "Reload buffers edited by opencode",
})
```

**Why `vim.o.autoread = true` is necessary:**
- `:checktime` is Neovim's command for reloading changed files
- `autoread` allows `:checktime` to automatically reload buffers
- Without it, buffers must be manually reloaded

**Health Check** ([permalink](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/lua/opencode/health.lua)):
```lua
if require("opencode.config").opts.events.reload and not vim.o.autoread then
  vim.health.warn(
    "`opts.events.reload = true` but `vim.o.autoread = false`: "
    .. "files edited by `opencode` won't be automatically reloaded in buffers.",
    {
      "Set `vim.o.autoread = true`",
      "Or set `vim.g.opencode_opts.events.reload = false`",
    }
  )
end
```

Run `:checkhealth opencode` after setup to verify configuration.

---

## 6. CUSTOM SNACKS TERMINAL INTEGRATION

### 6.1 Using snacks.terminal Instead

For a more integrated experience, you can use snacks.terminal ([README.md](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/README.md#customization)):

```lua
local opencode_cmd = 'opencode --port'
---@type snacks.terminal.Opts
local snacks_terminal_opts = {
  win = {
    position = 'right',
    enter = false,
    on_win = function(win)
      require('opencode.terminal').setup(win.win)
    end,
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    start = function()
      require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
    end,
    stop = function()
      require('snacks.terminal').get(opencode_cmd, snacks_terminal_opts):close()
    end,
    toggle = function()
      require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
    end,
  },
}
```

---

## 7. EVENT HANDLING & AUTOCMDS

### 7.1 Listening to opencode Events

The plugin forwards opencode's Server-Sent Events as `OpencodeEvent` autocmds ([README.md](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/README.md#-events)):

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "OpencodeEvent:*",  -- Wildcard for all events
  callback = function(args)
    ---@type opencode.cli.client.Event
    local event = args.data.event
    ---@type number
    local port = args.data.port

    vim.notify(vim.inspect(event))
    
    -- Example: React to specific event types
    if event.type == "session.idle" then
      vim.notify("`opencode` finished responding")
    end
  end,
})
```

**Available Event Types:**
- `file.edited` - File modified by opencode
- `session.idle` - Session waiting for input
- `permission.requested` - Permission needed
- `session.created` - New session started
- And more...

### 7.2 Permission Requests

When opencode requests a permission, the plugin waits for idle to prompt you:

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "OpencodeEvent:permission.requested",
  callback = function(args)
    local event = args.data.event
    -- event.permission contains the permission details
    -- Respond with approval/denial
  end,
})
```

---

## 8. EXPERIMENTAL LSP INTEGRATION

### 8.1 In-Process LSP

v0.4.0 added experimental LSP support ([CHANGELOG.md](https://github.com/nickjvandyke/opencode.nvim/blob/1b90ae8936245255786b7789496f7d910ab8434d/CHANGELOG.md#040-2026-02-20)):

```lua
vim.g.opencode_opts = {
  lsp = {
    enabled = true,  -- Enable experimental LSP
    filetypes = nil,  -- Apply to all filetypes
    handlers = {
      hover = {
        enabled = true,
        model = nil,  -- Use default model
      },
      code_action = { enabled = true },
    },
  },
}
```

**Features:**
- **Hover:** Ask opencode to explain the symbol under cursor
- **Code Actions:** Ask opencode to explain or fix diagnostics

**Status:** Disabled by default for stability. Enable with caution.

---

## 9. INTEGRATION WITH OTHER AI PLUGINS

### 9.1 Avoiding Conflicts

**Key Remapping Considerations:**

If you use other AI plugins (aider.nvim, copilot, etc.), consider:

1. **Prefix-based keymaps** to avoid conflicts:
   ```lua
   vim.keymap.set({ "n", "x" }, "<leader>oa", 
     function() require("opencode").ask() end,
     { desc = "opencode: Ask" }
   )
   vim.keymap.set({ "n", "x" }, "<leader>ox",
     function() require("opencode").select() end,
     { desc = "opencode: Select" }
   )
   ```

2. **Optional dependencies** in lazy.nvim:
   ```lua
   {
     "nickjvandyke/opencode.nvim",
     optional = true,  -- Allow disabling without breaking deps
   }
   ```

3. **Conditional setup** based on environment:
   ```lua
   config = function()
     if os.getenv("USE_OPENCODE") == "1" then
       vim.g.opencode_opts = { ... }
     end
   end,
   ```

### 9.2 Completion Plugin Compatibility

The plugin's LSP completion works with:
- **blink.cmp** - Supported via in-process LSP
- **nvim-cmp** - Supported via custom source
- **vim.ui.input** - Built-in fallback with customlist completion

---

## 10. COMMON CONFIGURATION PATTERNS

### 10.1 Minimal Setup

```lua
{
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = { "folke/snacks.nvim", optional = true },
  config = function()
    vim.o.autoread = true
    vim.keymap.set({ "n", "x" }, "<C-a>",
      function() require("opencode").ask() end
    )
  end,
}
```

### 10.2 Custom Prompts

```lua
vim.g.opencode_opts = {
  prompts = {
    refactor = {
      prompt = "Refactor @this for better performance and readability",
      submit = true,
    },
    security_audit = {
      prompt = "Audit @this for potential security vulnerabilities",
      submit = true,
    },
  },
}
```

### 10.3 Custom Contexts

```lua
vim.g.opencode_opts = {
  contexts = {
    ["@env"] = function(context)
      -- Return environment-specific context
      return "Environment: " .. vim.fn.system("uname -a"):gsub("\n", "")
    end,
  },
}
```

### 10.4 Port Configuration (For Remote Server)

```lua
vim.g.opencode_opts = {
  server = {
    port = 8765,  -- Connect to existing instance
    -- Don't define start/stop/toggle if connecting to external server
  },
}
```

---

## 11. EDGE CASES & TROUBLESHOOTING

### 11.1 Autoread with Modified Buffers

**Edge Case:** If a buffer has unsaved changes and opencode edits it, `:checktime` won't reload it.

**Solution:** Check for this in the autocmd:
```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "OpencodeEvent:file.edited",
  callback = function(args)
    if not vim.bo.modified then
      vim.cmd("checktime")
    end
  end,
})
```

### 11.2 Server Port Already in Use

**Edge Case:** Multiple opencode instances on same port.

**Solution:** Let opencode find a free port:
```lua
vim.g.opencode_opts = {
  server = {
    port = nil,  -- nil = autodetect
  },
}
```

### 11.3 Performance with Large Buffers

**Edge Case:** `:checktime` on very large projects can be slow.

**Workaround:** Only reload specific files:
```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "OpencodeEvent:file.edited",
  callback = function(args)
    local file = args.data.event.file
    local bufnr = vim.fn.bufloaded(file)
    if bufnr > 0 then
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("edit!")
      end)
    end
  end,
})
```

---

## 12. VERIFICATION & HEALTH CHECKS

Run this after setup:
```vim
:checkhealth opencode
```

Checks verify:
- opencode binary is available
- snacks.nvim is installed (if using)
- `vim.o.autoread` is enabled (if using events.reload)
- LSP configuration is valid
- Port is accessible

---

## 13. QUICK REFERENCE: KEY APIs

```lua
require("opencode").ask(prompt?, opts?)      -- Input prompt for opencode
require("opencode").select()                  -- Select from prompts/commands
require("opencode").prompt(text)              -- Send prompt directly
require("opencode").operator(prefix)          -- Operator-pending mode
require("opencode").command(cmd)              -- Send command (e.g., "session.new")
require("opencode").toggle()                  -- Toggle embedded terminal
require("opencode").statusline()              -- For lualine integration
require("opencode").snacks_picker_send(...)  -- Send picker items to opencode
```

---

## 14. RECENT CHANGES (v0.4.0, Feb 2026)

Major features added:
- ✅ Experimental in-process LSP with hover and code actions
- ✅ snacks.picker action to send items to opencode
- ✅ Improved append behavior with `<S-CR>` in ask
- ✅ Reliable terminal cleanup
- ✅ Multi-model support in LSP

---

## 15. RESOURCES

| Resource | URL |
|----------|-----|
| Official README | https://github.com/nickjvandyke/opencode.nvim#readme |
| nixvim Documentation | https://nix-community.github.io/nixvim/plugins/opencode/index.html |
| Config Type Definitions | https://github.com/nickjvandyke/opencode.nvim/blob/main/lua/opencode/config.lua |
| Changelog | https://github.com/nickjvandyke/opencode.nvim/blob/main/CHANGELOG.md |
| Issues & Discussions | https://github.com/nickjvandyke/opencode.nvim/issues |

