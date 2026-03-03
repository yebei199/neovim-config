# 自动格式化与防抖延迟实施计划

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 实现任何有 formatter 的文件在修改后 3 秒自动格式化，诊断实时显示，Rust 启用 clippy 诊断。

**Architecture:** 
1. **Nix 层**：补充缺失的 formatter 工具声明，使系统中可用所有需要的格式化器
2. **Autocmd 层**：从 BufWritePre（保存时）改为 TextChanged（修改时）+ 缓冲区级防抖 timer，实现 3 秒延迟
3. **Rust 层**：补充 checkOnSave 配置明确指定 clippy 命令，启用完整的 Clippy 检查

**Tech Stack:** Nix (home-manager), Lua (neovim autocommands), conform.nvim

---

## Task 1: 在 nix/neovim.nix 添加缺失的 Formatter

**Files:**
- Modify: `nix/neovim.nix:8-22` (home.packages 列表)

**Step 1: 确认当前 Formatter 列表**

打开 `nix/neovim.nix` 查看 home.packages，当前已有：
- `biome`, `tailwindcss`, `prettier`, `vscode-langservers-extracted`

缺失：
- `stylua` (Lua formatter)
- `fourmolu` (Haskell formatter)
- `cabal-fmt` (Cabal formatter)
- `clang-tools` (含 clang-format，C++ formatter)
- `alejandra` (Nix formatter，当前用 nixfmt，可选保留 nixfmt)

**Step 2: 添加缺失的 formatter 到 home.packages**

在 `nix/neovim.nix` 的 `home.packages = with pkgs;` 列表中添加：

```nix
home.packages = with pkgs; [
  gnumake
  ripgrep
  lsof
  neovide
  zk
  choose
  tokei

  biome
  tailwindcss
  astro-language-server
  prettier
  vscode-langservers-extracted
  
  # 新增：缺失的 Formatter
  stylua           # Lua formatter
  fourmolu         # Haskell formatter  
  cabal-fmt        # Cabal file formatter
  clang-tools      # 包含 clang-format for C++
];
```

**Step 3: 运行 nix flake update 和 home-manager switch**

```bash
cd /home/yb/RustroverProjects/neovim-config
nix flake update
home-manager switch --flake .
```

Expected: home-manager 输出激活脚本，stylua/fourmolu/cabal-fmt/clang-tools 被安装

**Step 4: 验证工具已安装**

```bash
which stylua fourmolu cabal-fmt clang-format
```

Expected: 所有工具的路径都输出（都在 /etc/profiles/per-user/yb/bin/ 或 /nix/store 中）

**Step 5: 测试 stylua 格式化**

```bash
cat > /tmp/test.lua << 'EOF'
local   x   =   1
local y=2
EOF
stylua /tmp/test.lua && cat /tmp/test.lua
```

Expected: 代码被正确格式化为规范形式

**Step 6: Commit**

```bash
git add nix/neovim.nix
git commit -m "feat: add missing formatters (stylua, fourmolu, cabal-fmt, clang-tools)"
```

---

## Task 2: 移除 BufWritePre 自动格式化，准备新机制

**Files:**
- Modify: `lua/config/autocmds/init.lua:14-20`

**Step 1: 备份当前自动命令**

查看 `lua/config/autocmds/init.lua` 的 BufWritePre 部分：

```lua
-- Auto Format
autocmd("BufWritePre", {
  desc = "Auto Format buffer",
  callback = function(args)
    if vim.g.autoformat and vim.b.autoformat ~= false then require("conform").format { bufnr = args.buf } end
  end,
})
```

**Step 2: 注释掉 BufWritePre 自动格式化（暂时保留，后续由新机制完全替代）**

注释这个自动命令，改为：

```lua
-- DEPRECATED: Auto Format on save - 已移至 TextChanged 防抖机制
-- autocmd("BufWritePre", {
--   desc = "Auto Format buffer",
--   callback = function(args)
--     if vim.g.autoformat and vim.b.autoformat ~= false then require("conform").format { bufnr = args.buf } end
--   end,
-- })
```

**Step 3: Commit**

```bash
git add lua/config/autocmds/init.lua
git commit -m "refactor: disable BufWritePre auto-format, preparing TextChanged debounce mechanism"
```

---

## Task 3: 实现缓冲区级防抖延迟格式化（TextChanged + Timer）

**Files:**
- Modify: `lua/config/autocmds/init.lua` (在注释之后添加新的自动命令)

**Step 1: 理解防抖需求**

- 监听 `TextChangedI` (插入模式修改) 和 `TextChanged` (其他模式修改)
- 每次修改时，如果已有 timer 存在则取消，创建新的 3 秒 timer
- 3 秒后如果缓冲区仍未保存，执行格式化
- 缓冲区关闭或保存时清理 timer

**Step 2: 添加缓冲区级 timer 跟踪和防抖函数**

在 `lua/config/autocmds/init.lua` 开头添加：

```lua
local debounce_timers = {}  -- 跟踪每个缓冲区的 timer

local function setup_debounce_format(bufnr)
  -- 如果该缓冲区已有 timer，取消它
  if debounce_timers[bufnr] then
    vim.fn.timer_stop(debounce_timers[bufnr])
  end

  -- 创建新的 timer，3 秒后执行格式化
  debounce_timers[bufnr] = vim.fn.timer_start(3000, function()
    -- 确保缓冲区仍然存在且有效
    if vim.api.nvim_buf_is_valid(bufnr) and vim.g.autoformat and vim.b[bufnr].autoformat ~= false then
      local ok = pcall(require("conform").format, { bufnr = bufnr, async = true })
      if not ok then
        -- 格式化失败（可能是工具不存在），静默忽略
      end
    end
    -- 清理 timer 引用
    debounce_timers[bufnr] = nil
  end, { ["repeat"] = 1 })
end

local function cleanup_debounce_timer(bufnr)
  if debounce_timers[bufnr] then
    vim.fn.timer_stop(debounce_timers[bufnr])
    debounce_timers[bufnr] = nil
  end
end
```

**Step 3: 添加 TextChanged 自动命令触发防抖**

在上述函数定义之后添加：

```lua
-- Debounced Auto Format (3 seconds after modification)
autocmd({ "TextChanged", "TextChangedI" }, {
  desc = "Trigger debounced format on text change",
  callback = function(args)
    setup_debounce_format(args.buf)
  end,
})
```

**Step 4: 添加缓冲区关闭时的清理**

```lua
-- Cleanup debounce timer on buffer delete
autocmd("BufUnload", {
  desc = "Cleanup debounce timer",
  callback = function(args)
    cleanup_debounce_timer(args.buf)
  end,
})
```

**Step 5: 测试防抖格式化**

创建测试文件 `/tmp/test_debounce.lua`：

```lua
local   x   =   1
local y=2
```

在 Neovim 中打开：
```bash
nvim /tmp/test_debounce.lua
```

- 修改文件（例如在第一行加空格）
- 等待 3 秒，观察是否自动格式化
- 如果有多个 formatter 配置，确认使用了正确的 formatter

**Step 6: Commit**

```bash
git add lua/config/autocmds/init.lua
git commit -m "feat: implement debounced auto-format with 3-second delay

- Add per-buffer timer tracking for debounce mechanism
- Monitor TextChanged/TextChangedI events
- Format triggers 3 seconds after last modification
- Cleanup timers on buffer close to prevent leaks
- Use async formatting to avoid blocking editor"
```

---

## Task 4: 补充 Rust clippy 诊断配置

**Files:**
- Modify: `lua/config/langs/rust.lua:27-44` (default_settings 部分)

**Step 1: 查看当前 rust-analyzer 配置**

打开 `lua/config/langs/rust.lua`，找到 `checkOnSave = true` 部分。

当前配置：
```lua
default_settings = {
  ["rust-analyzer"] = {
    cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
    checkOnSave = true,  -- 简单布尔值，使用默认行为
    diagnostics = { enable = true },
    ...
  }
}
```

**Step 2: 将 checkOnSave 从布尔值改为详细配置，明确指定 clippy**

替换：
```lua
default_settings = {
  ["rust-analyzer"] = {
    cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
    checkOnSave = {
      command = "clippy",
      extraArgs = { "--all-targets", "--all-features" },
    },
    diagnostics = { enable = true },
    ...
  }
}
```

**Step 3: 理解配置含义**

- `command = "clippy"` — 使用 clippy 而非默认的 `check` 命令
- `extraArgs = { "--all-targets", "--all-features" }` — 检查所有目标和所有特性，获得最完整的 linting

**Step 4: 测试 Clippy 诊断**

创建有警告的 Rust 文件 `/tmp/test_clippy.rs`：

```rust
fn main() {
    let _unused = 42;  // 未使用变量警告
    println!("Hello");
}
```

在 Neovim 中打开：
```bash
nvim /tmp/test_clippy.rs
```

Expected: 
- rust-analyzer 启动后，应该显示 clippy 警告（例如 "variable assigned to itself" 或 "unused variable"）
- 在诊断窗口或行号栏看到警告标记

**Step 5: 观察诊断反馈**

可选验证：
```bash
cd /tmp && cargo init test_clippy --name test_clippy
cp test_clippy.rs test_clippy/src/main.rs
cd test_clippy && cargo clippy
```

Expected: cargo clippy 应输出相同的警告

**Step 6: Commit**

```bash
git add lua/config/langs/rust.lua
git commit -m "feat: enable clippy linting in rust-analyzer

- Change checkOnSave from boolean to detailed config
- Set command to 'clippy' for comprehensive linting
- Add --all-targets and --all-features flags
- Ensures all potential issues are caught"
```

---

## Task 5: 验证完整流程和边界条件

**Files:**
- Test files (no permanent changes)

**Step 1: 验证多个文件同时延迟格式化**

创建两个测试文件：

```bash
cat > /tmp/test1.lua << 'EOF'
local   x=1
EOF

cat > /tmp/test2.py << 'EOF'
x  =  1
EOF
```

在 Neovim 中：
```bash
nvim /tmp/test1.lua /tmp/test2.py
```

- 在 test1.lua 中修改（触发 Lua 格式化 timer）
- 按 `Ctrl-w` 切换到 test2.py 修改（触发 Python 格式化 timer）
- 等待 3 秒，两个文件应该都被格式化

**Step 2: 验证保存时的行为**

- 修改一个文件
- 不等 3 秒，立即保存 `:w`
- 确认：a) 文件被保存；b) 格式化 timer 被清理

**Step 3: 验证禁用自动格式化**

```bash
# 缓冲区级禁用
:let b:autoformat = 0

# 修改文件，3 秒后不应该格式化

# 全局禁用  
:let g:autoformat = 0
```

Expected: 修改后 3 秒不执行格式化

**Step 4: 验证诊断仍然实时显示**

在 Rust 文件中：
- 输入有错误的代码
- 诊断应该实时（无延迟）显示在行号栏或诊断窗口
- 确认：格式化延迟不影响诊断实时性

**Step 5: 验证没有内存泄漏**

监听 Neovim 进程内存（可选，如果编辑很多文件）：

```bash
ps aux | grep nvim | grep -v grep
```

打开和关闭多个缓冲区，确认没有 timer 堆积。

**Step 6: Commit (如果有任何测试代码变更)**

```bash
git add lua/config/autocmds/init.lua
git commit -m "test: verify debounce formatting and edge cases"
```

---

## Task 6: 更新文档

**Files:**
- Modify: `docs/architecture.md` (可选，如果要记录新的自动命令设计)
- Modify: `docs/keymap.md` (可选，如果有相关快捷键)

**Step 1: 更新 architecture.md 中的自动命令部分**

在 `docs/architecture.md` 的"核心结构"或新的"自动化"章节添加：

```markdown
## 自动化机制

### 格式化

采用防抖延迟策略：任何有 formatter 的文件在修改后 3 秒自动格式化，使用缓冲区级 timer 独立管理，避免频繁重排。

- 监听：`TextChanged`, `TextChangedI` 事件
- 延迟：3 秒防抖（每次修改重置 timer）
- 清理：缓冲区关闭时释放 timer
- 支持的文件类型：Lua (stylua), Rust (rustfmt), Python (ruff), Nix (nixfmt), JavaScript (prettier), HTML/CSS (biome), C++ (clang-format), Haskell (fourmolu), Cabal (cabal-fmt)

### 诊断

- LSP 诊断：实时显示，无延迟
- Rust clippy：在保存时和修改时由 rust-analyzer checkOnSave 异步执行
- 显示方式：行号栏图标 + 浮动窗口 + 诊断汇总 (trouble.nvim)
```

**Step 2: 如有快捷键相关变更，更新 keymap.md**

当前自动格式化用 `<leader>cf` 手动触发，防抖格式化是自动的，无需快捷键。

**Step 3: Commit (可选)**

```bash
git add docs/architecture.md
git commit -m "docs: document debounced auto-format mechanism"
```

---

## 总体 Commit 日志预期

完成所有任务后，git log 应如下所示：

```
* docs: document debounced auto-format mechanism
* feat: enable clippy linting in rust-analyzer
* feat: implement debounced auto-format with 3-second delay
* refactor: disable BufWritePre auto-format, preparing TextChanged debounce mechanism
* feat: add missing formatters (stylua, fourmolu, cabal-fmt, clang-tools)
```

---

## 关键设计决策

1. **防抖级别**：缓冲区级而非全局级，允许多个文件同时独立延迟格式化
2. **异步格式化**：使用 `async = true` 避免阻塞编辑器，但对 stylua 等快速 formatter 影响不大
3. **Timer 清理**：BufUnload 时清理，确保不留悬挂 timer
4. **诊断独立**：格式化延迟不影响诊断实时性，LSP checkOnSave 独立运行
5. **工具依赖**：所有 formatter 必须在 Nix 中声明，不依赖系统已安装的工具
