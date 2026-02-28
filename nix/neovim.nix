# nix/neovim.nix - Neovim 编辑器配置、文件链接和开发工具
# 集中管理：packages（工具依赖）、xdg.configFile（配置文件链接）、programs.neovim（编辑器设置）
# lazy.nvim 通过 activation script 首次 clone，后续由 lazy.nvim 自身管理，避免 symlink 冲突
{ pkgs, lib, nvim_config_src, ... }:
{
  config = {
    # Neovim 开发工具和相关依赖
    home.packages = with pkgs; [
      gnumake
      ripgrep
      neovide
      zk
      choose

      biome
      tailwindcss
      astro-language-server
      prettier
      vscode-langservers-extracted
    ];
    # 首次 home-manager switch 时 clone lazy.nvim，目录已存在则跳过
    # 后续由 lazy.nvim 自身通过 git 管理更新，不再由 Nix 介入
    home.activation.bootstrapLazyNvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      lazydir="$HOME/.local/share/nvim/lazy/lazy.nvim"
      if [ ! -d "$lazydir" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone \
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
