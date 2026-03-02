# nix/github.nix - GitHub 相关工具链和命令行工具
# 声明 GitHub 交互、版本控制和文本对比所需的 CLI 工具
# gh-notify 通过 activation script 安装以获取最新版，其余工具由 Nix 统一管理
# systemd 环境无 ssh/git：需显式注入 git 路径并通过 GIT_CONFIG 强制 HTTPS
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
    # systemd 环境无 git/ssh：显式注入 git PATH，并通过 GIT_CONFIG_* 强制 HTTPS 避免 SSH fork 失败
    home.activation.installGhNotify = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0="url.https://github.com/.insteadOf"
      export GIT_CONFIG_VALUE_0="git@github.com:"
      if ! ${pkgs.gh}/bin/gh extension list 2>/dev/null | grep -q "meiji163/gh-notify"; then
        $DRY_RUN_CMD ${pkgs.gh}/bin/gh extension install meiji163/gh-notify
      fi
    '';
  };
}
