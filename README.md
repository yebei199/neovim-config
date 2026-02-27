## 安装

### 插件管理器（Plugins manager）

配置不会自动安装 [`lazy.nvim`](https://lazy.folke.io)
```bash
git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
```


## Features

### Language

我把语言相关的配置都放在了一块，
这比分别在 [conform.nvim](https://github.com/stevearc/conform.nvim), [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) 和 `vim.lsp.config` 里面配置要更加方便管理一些

你可以把语言配置放在 `stdpath('config')/lua/langs`，
或者简单来说就是 `~/.config/nvim/lua/langs`

每个文件返回一张具有如下类型 `Config.LangConfig` 的表

| 值 | 类型  |描述  |
| --- | --- | -----|
| `[integer]` | `string` or `Config.LangConfig` | 你可以在语言配置里面嵌套多个语言的配置，下面会告诉你有什么用 |
| **treesitter** | `string[]` or `boolean` | 默认是 `true`，会自动安装 `treesitter-{language name}` |
| **lsp** | `string`, `string[]` or `table<string,lspconfig>` | 语言服务器的名字, 如果类型是 `table`, 就会执行 `vim.lsp.config(key, value)`  |
| **formatter** | `string` or `string[]`  | formmatter 的名字 |
| **pkgs** | `string[]` | 如果 [mason](https://github.com/mason-org/mason.nvim) 包的名字和上面使用的 lsp/formmatter 的名字不一样 , 你可以用这个来指定要安装的包 |
| **plugins** | `LazySpec` |和这个语言相关的 nvim 插件|
| **enabled** | `boolean` | 赋能传统语言文化配置 | 


关于配置语言的[示例](./Language.md)，我只写了英文版，开个翻译将就看呗

随便一提，我把我自己的语言配置放在了 `stdpath('config')/languages`, 你可以把他们复制到 `stdpath('config')/lua/langs` 里去

如果你喜欢这个功能，也可以提交一些你个人的语言配置到这里来。由于不会自动应用，所以无论什么语言都大欢迎！

### FileType Picker

用 <kbd>\<leader\>sf</kbd> 来 查找文件类型 *(search filetypes)*

https://github.com/user-attachments/assets/bbcee4b8-3e6b-42e8-ae0a-dbfd991ac677

通过上面的[语言配置功能](#language)，我还顺便展示了每个文件类型的配置情况

用 <kbd><Shift-Enter\></kbd> 来跳转到对应语言的配置文件

### Root and Cwd

我更倾向于直接将 Cwd 设置为项目根目录，LazyVim 每个快捷键都区分个 CWD 和 Root 让我感觉挺麻烦的

效果类似于 `'autochdir'`，每次进入新的 buffer 时将 CWD 切换到对应文件的项根目录

### Oil, Tabline and Harpoon

我挺赞同一些视频说：你不应该把 Neovim 定制成传统 IDE 那样

- 用 **tabline** 而不是 **bufferline**

  让 buffer 堆满你的 tabline 然后用 <kbd>H</kbd> / <kbd>L</kbd> 没头没脑地找吗? Vim 高尔夫大师是不会这样做的

- 不要依赖文件树来跳转文件，你应该用 File Picker 和 Harpoon

  不过虽然这么说，我还是在用 [snacks.explorer](https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md)

  用 File Tree 来总览一下项目结构还是蛮不错的

- [**Oil.nvim**](https://github.com/stevearc/oil.nvim) 真的很好用，而且很有 Vim 的风格，我很推荐你去试一试

  在日常的文件操作里，我一般会去用 Oil 而不是 [yazi](https://github.com/sxyazi/yazi)，Oil 高效又直观

### Kitty Scrollback

我还把 Neovim 设成了 [kitty](https://github.com/kovidgoyal/kitty) 的 scrollback pager

https://github.com/user-attachments/assets/4be81a21-441a-46ea-a361-4cfe66470cbb

受 [kitty-scrollback.nvim](https://github.com/mikesmithgh/kitty-scrollback.nvim) 的启发

不过我这里就只是单纯给 scrollback 着个色，然后设几个 keymap 和 option 而已，相当轻量化

你可以在 kitty 的配置里面设置下面的选项来启用这个功能

```bash
scrollback_pager nvim -c 'set filetype=scrollback'
```
