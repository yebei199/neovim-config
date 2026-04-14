# nix/github.nix - GitHub 相关工具链和命令行工具
# 声明 GitHub 交互、版本控制和文本对比所需的 CLI 工具
# 仅管理 gh、lazygit、meld、delta 等常用工具，避免额外的通知扩展安装逻辑
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

    # systemd 环境无 git/ssh：显式注入 git PATH，并通过 GIT_CONFIG_* 强制 HTTPS 避免 SSH fork 失败
    home.activation.githubHttpsOnly = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0="url.https://github.com/.insteadOf"
      export GIT_CONFIG_VALUE_0="git@github.com:"
    '';
  };
}
