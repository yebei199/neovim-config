# nix/neovim.nix - Neovim 编辑器配置、文件链接和开发工具
# 集中管理：packages（工具依赖）、xdg.configFile（配置文件链接）、programs.neovim（编辑器设置）
{ pkgs }:
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

    # 将项目配置文件递归链接到 ~/.config/nvim
    xdg.configFile."nvim" = {
      source = "/home/yb/RustroverProjects/neovim-config";
      recursive = true;
    };

    # Neovim 编辑器基础配置：启用编辑器，设置为默认编辑器
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
