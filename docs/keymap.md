# 快捷键速查表

> `<leader>` 默认为空格键。模式缩写：`n`=Normal，`i`=Insert，`v`=Visual，`x`=Visual Block，`o`=Operator，`s`=Select，`t`=Terminal，`c`=Command。

---

## 全局 / 通用

| 快捷键          | 模式      | 说明            |
|--------------|---------|---------------|
| `<C-s>`      | n/i/x/s | 保存文件          |
| `<C-A>`      | n       | 全选            |
| `<leader>qq` | n       | 退出所有窗口        |
| `<leader>ur` | n       | 清除高亮 / 刷新差异   |
| `<leader>n`  | n       | 查看通知历史        |
| `<leader>l`  | n       | 打开 Lazy 插件管理器 |
| `<leader>K`  | n       | 查看关键字文档       |
| `dm`         | n       | 删除所有标记        |

### 光标移动

| 快捷键       | 模式    | 说明                 |
|-----------|-------|--------------------|
| `j` / `k` | n/x   | 智能上下移动（支持软换行）      |
| `<UP>`    | n     | 向上翻半屏 `<C-u>`      |
| `<Down>`  | n     | 向下翻半屏 `<C-d>`      |
| `<Left>`  | n     | 向上翻整屏 `<C-b>`      |
| `<Right>` | n     | 向下翻整屏 `<C-f>`      |
| `n` / `N` | n/x/o | 跳转到下/上一个搜索结果（方向感知） |

### 行移动

| 快捷键     | 模式    | 说明         |
|---------|-------|------------|
| `<A-j>` | n/i/v | 当前行/选区向下移动 |
| `<A-k>` | n/i/v | 当前行/选区向上移动 |

### 编辑辅助

| 快捷键                      | 模式    | 说明            |
|--------------------------|-------|---------------|
| `<` / `>`                | v     | 缩进后保持选区       |
| `<C-CR>`                 | i     | 在行尾换行         |
| `<C-S-V>` / `<S-Insert>` | i/c/t | 粘贴            |
| `<C-BS>`                 | i/c   | 向前删除一个单词      |
| `<C-Delete>`             | i/c   | 向后删除一个单词      |
| `<esc><esc>`             | t     | 退出终端插入模式      |
| `,` `.` `;`              | i     | 输入标点时自动创建撤销锚点 |

### 文本缩写（Insert 模式自动替换）

| 缩写      | 替换为     |
|---------|---------|
| `cosnt` | `const` |
| `mian`  | `main`  |

---

## 文件 `<leader>f`

| 快捷键               | 说明                     |
|-------------------|------------------------|
| `<leader><space>` | 智能文件选择                 |
| `<leader>ff`      | 查找文件                   |
| `<leader>fr`      | 最近文件                   |
| `<leader>fb`      | 缓冲区列表                  |
| `<leader>fg`      | Git 跟踪文件               |
| `<leader>fp`      | 项目列表                   |
| `<leader>fz`      | Zoxide 目录跳转            |
| `<leader>fc`      | Neovim 配置文件            |
| `<leader>f.`      | Dotfile 目录             |
| `<leader>fn`      | 新建文件                   |
| `<leader>fs`      | 打开草稿缓冲区                |
| `<leader>fS`      | 选择草稿缓冲区                |
| `<leader>fy`      | 打开 Yazi 文件管理器          |
| `<leader>e`       | 打开文件树（Snacks Explorer） |
| `<BS>`            | 打开 Oil 文件浏览器           |
| `<leader>fo`      | Oil 浮动窗口               |

### Oil 内部快捷键

| 快捷键          | 说明             |
|--------------|----------------|
| `<CR>`       | 打开文件/目录        |
| `\|`         | 垂直分割打开         |
| `-`          | 水平分割打开         |
| `<C-c>`      | 关闭 Oil         |
| `K`          | 预览             |
| `<BS>`       | 返回上级目录         |
| `g?`         | 帮助             |
| `gx`         | 用外部程序打开        |
| `<C-y>`      | 复制到系统剪贴板       |
| `<C-p>`      | 从系统剪贴板粘贴       |
| `<leader>R`  | 刷新             |
| `<leader>oh` | 打开 cwd         |
| `<leader>os` | 更改排序           |
| `<leader>uh` | 切换隐藏文件         |
| `<leader>or` | 切换回收站          |
| `<leader>od` | 切换详细信息         |
| `<c-\>`      | 在当前目录打开终端      |
| `<leader>fz` | 通过 Zoxide 跳转目录 |

---

## 搜索 `<leader>s`

| 快捷键          | 说明                |
|--------------|-------------------|
| `<leader>S`  | 所有搜索器             |
| `<leader>sg` | Grep 搜索           |
| `<leader>sw` | 搜索当前光标词（n/x）      |
| `<leader>sb` | 缓冲区内容行搜索          |
| `<leader>sB` | 多缓冲区 Grep         |
| `<leader>sr` | 搜索/替换（grug-far）   |
| `<leader>sd` | 诊断列表              |
| `<leader>sD` | 缓冲区诊断列表           |
| `<leader>sh` | 帮助页面              |
| `<leader>sk` | 快捷键列表             |
| `<leader>sc` | 命令列表              |
| `<leader>s:` | 命令历史              |
| `<leader>s/` | 搜索历史              |
| `<leader>s"` | 寄存器列表             |
| `<leader>sm` | 标记列表              |
| `<leader>sj` | 跳转列表              |
| `<leader>sa` | 自动命令列表            |
| `<leader>sq` | 快速修复列表            |
| `<leader>sl` | 本地快速修复列表          |
| `<leader>sp` | 插件列表              |
| `<leader>su` | 撤销树               |
| `<leader>sn` | 通知记录              |
| `<leader>sf` | 文件类型列表            |
| `<leader>si` | 图标列表              |
| `<leader>st` | Todo 注释           |
| `<leader>sT` | Todo/Fix/Fixme 注释 |

---

## LSP / 代码 `<leader>c` / `g`

| 快捷键          | 模式  | 说明                |
|--------------|-----|-------------------|
| `gd`         | n   | 跳转到定义             |
| `gD`         | n   | 跳转到声明             |
| `gr`         | n   | 查找引用              |
| `gI`         | n   | 跳转到实现             |
| `gt`         | n   | 跳转到类型定义           |
| `<leader>ss` | n   | LSP 符号列表          |
| `<leader>sS` | n   | LSP 工作区符号列表       |
| `<leader>cl` | n   | LSP 配置            |
| `<leader>ci` | n   | 检查光标所在位置信息        |
| `<leader>cr` | n   | 重命名符号             |
| `<leader>cd` | n   | 显示行诊断             |
| `<leader>xp` | n   | 预览诊断              |
| `<leader>cf` | n/v | 格式化代码             |
| `<leader>cs` | n   | Trouble 符号面板      |
| `<leader>cS` | n   | Trouble LSP 定义/引用 |
| `<leader>cI` | n   | 检查语法树             |
| `gco`        | n   | 在下方添加注释           |
| `gcO`        | n   | 在上方添加注释           |

### 诊断跳转

| 快捷键         | 说明        |
|-------------|-----------|
| `[d` / `]d` | 上/下一个诊断   |
| `[D` / `]D` | 第一/最后一个诊断 |
| `[e` / `]e` | 上/下一个错误   |
| `[w` / `]w` | 上/下一个警告   |
| `[[` / `]]` | 上/下一个引用   |

### Trouble 快速修复

| 快捷键          | 说明                       |
|--------------|--------------------------|
| `<leader>xx` | 诊断列表                     |
| `<leader>xX` | 缓冲区诊断列表                  |
| `<leader>xq` | 快速修复列表                   |
| `<leader>xQ` | 本地快速修复列表                 |
| `[q` / `]q`  | 上/下一个 Trouble/Quickfix 项 |

### Snippet 跳转

| 快捷键       | 模式    | 说明                 |
|-----------|-------|--------------------|
| `<Tab>`   | s     | 跳转到下一个 snippet 占位符 |
| `<S-Tab>` | i/s   | 跳转到上一个 snippet 占位符 |
| `<esc>`   | i/n/s | 退出并清除高亮/解除 snippet |

---

## Git `<leader>g` / `<leader>gh`

| 快捷键          | 模式  | 说明         |
|--------------|-----|------------|
| `<leader>gg` | n   | 打开 Lazygit |
| `<leader>gs` | n   | Git 状态     |
| `<leader>gd` | n   | Git Diff   |
| `<leader>gS` | n   | Git Stash  |
| `<leader>gl` | n   | Git 日志     |
| `<leader>gf` | n   | 当前文件历史     |
| `<leader>gb` | n   | 当前行 Blame  |
| `<leader>gB` | n/x | 在浏览器中打开    |
| `<leader>gY` | n   | 复制 Git 链接  |

### Gitsigns Hunk（缓冲区内）

| 快捷键           | 模式  | 说明            |
|---------------|-----|---------------|
| `<leader>ghs` | n/v | Stage hunk    |
| `<leader>ghr` | n/v | Reset hunk    |
| `<leader>ghu` | n   | 撤销 stage      |
| `<leader>ghS` | n   | Stage 整个缓冲区   |
| `<leader>ghR` | n   | Reset 整个缓冲区   |
| `<leader>ghp` | n   | 内联预览 hunk     |
| `<leader>ghK` | n   | 预览 hunk       |
| `<leader>ghb` | n   | Blame 当前行（完整） |
| `<leader>ghB` | n   | Blame 整个缓冲区   |
| `<leader>ghd` | n   | Diff          |
| `<leader>ghD` | n   | Diff ~        |
| `]h` / `[h`   | n   | 下/上一个 hunk    |
| `]H` / `[H`   | n   | 最后/第一个 hunk   |
| `ah` / `ih`   | o/x | 选择 hunk 文本对象  |

---

## 窗口 & 缓冲区 & 标签页

### 窗口

| 快捷键             | 说明       |
|-----------------|----------|
| `<C-h/j/k/l>`   | 在窗口间移动   |
| `<C-S-h/j/k/l>` | 调整窗口大小   |
| `<leader>-`     | 向下分割     |
| `<leader>\|`    | 向右分割     |
| `<leader>wd`    | 关闭当前窗口   |
| `<leader>wm`    | 最大化/缩放窗口 |

### 缓冲区

| 快捷键          | 说明             |
|--------------|----------------|
| `<leader>bb` | 切换到上一个缓冲区      |
| `<leader>bd` | 删除当前缓冲区        |
| `<leader>bo` | 删除其他缓冲区        |
| `<leader>bD` | 强制关闭缓冲区（`:bd`） |

### 标签页

| 快捷键              | 说明      |
|------------------|---------|
| `<S-l>`          | 下一个标签页  |
| `<S-h>`          | 上一个标签页  |
| `<leader><tab>n` | 新建标签页   |
| `<leader><tab>d` | 关闭标签页   |
| `<leader><tab>o` | 关闭其他标签页 |
| `<leader><tab>f` | 第一个标签页  |
| `<leader><tab>l` | 最后一个标签页 |
| `<leader><tab>H` | 标签页向左移动 |
| `<leader><tab>L` | 标签页向右移动 |

---

## 任务运行 `<leader>o`（Overseer）

| 快捷键          | 说明    |
|--------------|-------|
| `<leader>ow` | 任务列表  |
| `<leader>oo` | 运行任务  |
| `<leader>oq` | 快速操作  |
| `<leader>oi` | 任务信息  |
| `<leader>ob` | 任务构建器 |
| `<leader>ot` | 任务动作  |
| `<leader>oc` | 清除缓存  |

---

## 功能开关 `<leader>u`

| 快捷键          | 说明          |
|--------------|-------------|
| `<leader>us` | 拼写检查        |
| `<leader>uw` | 自动换行        |
| `<leader>ul` | 行号          |
| `<leader>uL` | 相对行号        |
| `<leader>ud` | 诊断显示        |
| `<leader>uc` | 文本隐藏级别      |
| `<leader>uA` | 标签栏         |
| `<leader>uT` | Treesitter  |
| `<leader>ub` | 深色/浅色背景     |
| `<leader>uD` | 暗淡非焦点区域     |
| `<leader>ua` | 动画          |
| `<leader>ug` | 缩进参考线       |
| `<leader>uS` | 平滑滚动        |
| `<leader>uZ` | 缩放窗口        |
| `<leader>uz` | 禅模式         |
| `<leader>uh` | Inlay Hints |
| `<leader>uf` | 格式化（当前缓冲区）  |
| `<leader>uF` | 格式化（全局）     |

---

## Todo 注释

| 快捷键  | 说明          |
|------|-------------|
| `]t` | 下一个 Todo 注释 |
| `[t` | 上一个 Todo 注释 |

---

## 文件标记（Grapple）

| 快捷键 | 说明          |
|-----|-------------|
| `m` | 标记/取消标记当前文件 |
| `'` | 打开标记菜单      |

---

## 编辑增强

### Flash 快速跳转

| 快捷键         | 模式    | 说明                  |
|-------------|-------|---------------------|
| `f`         | n/x/o | Flash 跳转到字符         |
| `<C-space>` | o     | Flash Treesitter 选择 |
| `r`         | o     | Remote Flash        |
| `R`         | o/x   | Treesitter 搜索跳转     |

> Picker 内：`<M-x>` 或 `X` 触发 Flash 跳转

### 替换操作（Substitute）

| 快捷键   | 模式  | 说明                  |
|-------|-----|---------------------|
| `ds`  | n   | Substitute operator |
| `dss` | n   | Substitute 当前行      |
| `dS`  | n   | Substitute 到行尾      |
| `s`   | x   | Substitute 选区       |
| `#`   | n/x | Range Substitute    |
| `g#`  | n   | Range Substitute 命令 |
| `dx`  | n   | Exchange operator   |
| `dxx` | n   | Exchange 当前行        |
| `x`   | x   | Exchange 选区         |

### 包围符号（Surround）

| 快捷键            | 模式  | 说明                |
|----------------|-----|-------------------|
| `sa{char}`     | n/v | 添加包围符号            |
| `saa{char}`    | n   | 添加包围符号（光标词）       |
| `sA{char}`     | n/v | 添加行级包围符号          |
| `sd{char}`     | n   | 删除包围符号            |
| `sr{old}{new}` | n   | 替换包围符号            |
| `sR{old}{new}` | n   | 替换行级包围符号          |
| `<C-g>s`       | i   | Insert 模式添加包围符号   |
| `<C-g>S`       | i   | Insert 模式添加行级包围符号 |

### Yank 历史（Yanky）

| 快捷键         | 模式  | 说明              |
|-------------|-----|-----------------|
| `<leader>p` | n/x | Yank 历史         |
| `p`         | n/x | 粘贴到光标后          |
| `P`         | n/x | 粘贴到光标前          |
| `gp`        | n/x | 粘贴到选区后          |
| `gP`        | n/x | 粘贴到选区前          |
| `[y` / `]y` | n   | 向前/后循环 Yank 历史  |
| `[p` / `]p` | n   | 缩进粘贴到上/下行       |
| `[P` / `]P` | n   | 同上（大写别名）        |
| `>p` / `<p` | n   | 粘贴并右/左缩进        |
| `>P` / `<P` | n   | 粘贴前并右/左缩进       |
| `=p` / `=P` | n   | 粘贴后/前并过滤        |
| `iy` / `ay` | o/x | 选择上一次粘贴内容（文本对象） |

### 大小写/格式转换（Coerce）

| 前缀   | 模式  | 说明               |
|------|-----|------------------|
| `co` | n   | 转换光标词格式          |
| `sc` | n/v | Motion/Visual 转换 |

常见后缀（如 `cos` = snake_case，`coc` = camelCase，具体见 Coerce 文档）

---

## 文本对象（mini.ai）

使用 `a`/`i` 前缀（around/inside），`a]`/`i]` 为 next，`a[`/`i[` 为 prev：

| 对象        | 说明                       |
|-----------|--------------------------|
| `a`       | 函数参数                     |
| `b`       | `)]}` 任意括号               |
| `c`       | 类                        |
| `d`       | 数字                       |
| `e`       | CamelCase / snake_case 词 |
| `f`       | 函数体                      |
| `g`       | 整个缓冲区                    |
| `i`       | 缩进块                      |
| `o`       | block/conditional/loop   |
| `q`       | 引号 `` ` " ' ``           |
| `t`       | HTML 标签                  |
| `u` / `U` | 函数调用                     |
| `_`       | 下划线词                     |

---

## 终端

| 快捷键     | 说明        |
|---------|-----------|
| `<C-\>` | 打开/关闭浮动终端 |

---

## Kitty Scrollback（仅 `scrollback` 文件类型）

| 快捷键 | 说明 |
|-----|----|
| `q` | 退出 |
| `i` | 退出 |
