# nix/neovim.nix - Neovim 编辑器配置、文件链接和开发工具
# 集中管理：packages（工具依赖）、xdg.configFile（配置文件链接）、programs.neovim（编辑器设置）
# lazy.nvim 通过 activation script 首次 clone，后续由 lazy.nvim 自身管理，避免 symlink 冲突
{ pkgs, lib, nvim_config_src, ... }:
{
  config = {
    # Neovim 开发工具和相关依赖（含各语言 LSP、formatter、运行时工具）
    home.packages = with pkgs; [
      # 通用工具
      gnumake       # Makefile 构建
      ripgrep       # 全局代码搜索（telescope/snacks grep 后端）
      lsof          # 查看文件占用进程
      neovide       # Neovim GUI 前端
      zk            # Zettelkasten 笔记管理 CLI
      choose        # awk/cut 的现代替代，用于文本提取
      tokei         # 代码行数统计

      # Nix LSP & formatter
      nixd              # Nix LSP（nixd）
      nixfmt-rfc-style  # Nix formatter（nixfmt）

      # Lua LSP & formatter
      lua-language-server  # Lua LSP（lua_ls）
      stylua               # Lua formatter

      # Haskell LSP、formatter 及构建工具
      haskell-language-server  # Haskell LSP（haskell-language-server）
      fourmolu                 # Haskell formatter
      haskellPackages.cabal-fmt  # Cabal 文件 formatter

      # C/C++ LSP & formatter（clangd、clang-format 均包含于此）
      clang-tools  # clangd LSP + clang-format formatter

      # Python LSP & formatter
      pyright  # Python LSP（pyright）
      ruff     # Python linter & formatter

      # Web / Frontend LSP & formatter
      biome                    # JS/TS/JSON linter & formatter
      prettier                 # 通用 formatter（JS/TS/CSS/HTML 等）
      tailwindcss              # Tailwind CSS LSP（tailwindcss）
      astro-language-server    # Astro LSP（astro）
      vscode-langservers-extracted  # HTML/CSS/JSON/ESLint LSP
      vtsls                    # TypeScript/JavaScript LSP（vtsls）

      # Markdown LSP
      marksman  # Markdown LSP（marksman）

      # Fish shell LSP
      fish-lsp  # Fish LSP（fish_lsp）

      # Hyprlang LSP（Hyprland 配置文件）
      hyprls  # Hyprlang LSP（hyprls）

      # QML LSP（qmlls 二进制包含于 qtdeclarative）
      kdePackages.qtdeclarative  # QML LSP（qmlls）
    ];
    # 首次 home-manager switch 时 clone lazy.nvim，目录已存在则跳过
    # 后续由 lazy.nvim 自身通过 git 管理更新，不再由 Nix 介入
    # 注意：systemd 环境无 ssh，需禁用全局 insteadOf 规则强制 HTTPS
    home.activation.bootstrapLazyNvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      lazydir="$HOME/.local/share/nvim/lazy/lazy.nvim"
      if [ ! -d "$lazydir" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git \
          -c url."https://github.com/".insteadOf="git@github.com:" \
          clone \
          --filter=blob:none \
          --branch=stable \
          https://github.com/folke/lazy.nvim.git \
          "$lazydir"
      fi
    '';
    # 将项目配置文件递徒链接到 ~/.config/nvim
    xdg.configFile."nvim" = {
      source = "${nvim_config_src}";
      recursive = true;
    };

    # Neovim 编辑器基础配置：启用编辑器，设置为默认编辑器
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
