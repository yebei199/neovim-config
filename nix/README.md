# nix — Nix 环境声明模块

本目录以声明式方式定义 Neovim 运行环境所需的全部依赖，由项目根目录的 `flake.nix` 引入。Nix 的核心价值在于可复现性：所有插件版本通过 `flake.lock` 精确锁定，工具链（LSP、格式化器、CLI 工具）作为系统包声明，任何机器上 `nix build` 得到的结果都与 CI 完全一致，不依赖用户本地已安装的软件。

与 lazy.nvim 的 lockfile 机制不同，本项目将插件版本管理完全交给 Nix flake，lazy.nvim 仅负责运行时的懒加载调度，而非版本控制。这使得插件版本与系统级依赖（如 ripgrep、neovide）统一在一个声明文件中管理，升级时只需更新 flake inputs 后运行 `nix flake update`。

## 文件职责

**`neovim.nix`** 声明 Neovim 编辑器本身的完整环境：通过 `home.packages` 安装运行时依赖（ripgrep、neovide、zk、biome、prettier、tailwindcss、astro 语言服务器等），通过 `xdg.configFile."nvim"` 将本项目配置目录递归链接到 `~/.config/nvim`。lazy.nvim 插件管理器通过 home-manager activation script 在首次 `home-manager switch` 时自动 clone 到 `~/.local/share/nvim/lazy/lazy.nvim`；若目录已存在则跳过，后续由 lazy.nvim 自身通过 git 管理更新，Nix 不再介入版本控制，解决了符号链接导致 git 无法更新的问题。

**`rust.nix`** 声明 Rust 开发工具链，包括编译器、cargo 相关工具以及 Rust 开发所需的系统级依赖，与 Neovim 的 Rust LSP 配置（`langs/rust.lua`）协同工作，保证工具链版本与编辑器集成一致。

## 与其他目录的关系

`langs/` 目录中的语言配置描述"Neovim 侧如何集成某语言"，而本目录中的 nix 文件负责"该语言工具是否安装在系统上"。两者共同构成完整的语言支持链。
