# langs - 语言配置模块

本目录存放各种编程语言的配置模块，提供了一种统一且易于维护的语言支持管理方式。每个文件都是一个完整的语言配置，包含LSP服务器、代码格式化工具、Treesitter解析器和语言特定的插件设置。

## 目录结构

每个Lua文件对应一种编程语言，文件名为语言名称小写（如 `rust.lua`、`python.lua` 等）。

## 支持的语言

目前配置了以下语言：
- **C++** - cpp.lua，包含C++的LSP和格式化配置
- **Python** - python.lua，Python开发工具链配置
- **Rust** - rust.lua，Rust生态配置（包含rust-analyzer等）
- **Lua** - lua.lua，Neovim配置本身所用的Lua配置
- **JavaScript** - javascript.lua，JS/TS开发配置
- **Nix** - nix.lua，Nix表达式语言配置
- **Markdown** - markdown.lua，Markdown编写支持
- **HTML** - html.lua，Web前端开发支持
- **Fish** - fish.lua，Fish shell脚本编写支持
- **Haskell** - haskell.lua，函数式编程语言配置
- **QML** - qml.lua，Qt编程语言配置
- **Dotfiles** - dotfile.lua，配置文件编写支持

## 配置内容

每个语言配置文件通常包括：
- **LSP服务器** - 指定该语言的语言服务器（如rust-analyzer、pylance等）
- **格式化工具** - 代码自动格式化（如rustfmt、black等）
- **Treesitter解析器** - 语法树解析和高亮显示
- **Mason包管理** - LSP和工具的自动安装和管理
- **插件集成** - 语言特定的Neovim插件配置

## 设计优势

相比在多个配置文件中分散配置，统一的语言模块方式提供了：
- 集中管理，每种语言的配置在一个文件中完整呈现
- 易于维护，修改语言支持时只需编辑对应的单个文件
- 扩展性强，添加新语言只需创建新文件，无需修改系统其他部分
- 配置复用，相同配置可以在多个语言间共享
