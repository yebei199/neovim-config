# nix/github.nix - GitHub 相关工具链和命令行工具
# 声明 GitHub 交互、版本控制和文本对比所需的 CLI 工具
# gh-notify 通过 activation script 安装以获取最新版，其余工具由 Nix 统一管理
{ pkgs, lib, ... }:
{
  config = {
    home.packages = with pkgs; [
      gh
      lazygit
      meld
      delta
    ];

    # gh-notify 不经 nixpkgs 安装（版本严重滞后），通过 gh extension install 获取最新版
    # 已安装则跳过，后续由 gh extension upgrade 手动升级
    home.activation.installGhNotify = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! ${pkgs.gh}/bin/gh extension list 2>/dev/null | grep -q "meiji163/gh-notify"; then
        $DRY_RUN_CMD ${pkgs.gh}/bin/gh extension install meiji163/gh-notify
      fi
    '';
  };
}
