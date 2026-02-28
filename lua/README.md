# lua — Neovim 配置主体

整个配置的 Lua 代码根目录，按职责划分为三个独立层次，层与层之间单向依赖：utils 不依赖其他层，config 和 plugins 可调用 utils，config 和 plugins 互不依赖。

## 三层架构

**config/** 是编辑器初始化层，负责 Neovim 选项、快捷键绑定、自动命令注册、语言工具链加载编排。这一层直接与 Neovim API 交互，决定编辑器的基础行为。

**plugins/** 是插件声明层，每个文件返回 lazy.nvim 规范的插件 spec，不包含业务逻辑，仅描述插件来源、加载条件和配置回调。插件按功能分为 component、editor、lsp、ui、util 五个子目录。

**utils/** 是工具库层，提供供 config 和 plugins 调用的通用函数，包括文件系统操作、高亮组管理、语言配置解析、状态栏组件等。工具库本身不主动执行任何操作，仅对外暴露函数接口。

## 入口

Neovim 启动时加载 `init.lua`（位于配置根目录，非此目录），其中按顺序 require 各模块完成初始化。
