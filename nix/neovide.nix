# nix/neovide.nix - Neovide GUI 前端和相关配置
# 声明 Neovide（Neovim 的 GUI 客户端）的安装和 GUI 专属环境设置
# Lua 侧的 neovide 特定选项由 lua/config/neovide.lua 管理，仅在检测到 neovide 环境时加载
{ pkgs, ... }:
{
  config = {
    # 安装 Neovide GUI 前端
    home.packages = with pkgs; [
      neovide # Neovim GUI 前端
    ];
  };
}
