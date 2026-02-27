# nix/rust.nix - Rust toolchain and environment as home-manager module
# 将 Rust 工具链配置和环境变量作为 home-manager 模块导出
# 包含：完整工具链、SCCACHE、镜像配置
{ pkgs, ... }:
{
  config = {
    home.packages = [
      # Rust toolchain with extensions and targets
      (pkgs.rust-bin.stable.latest.default.override {
        extensions = [
          "rustfmt"
          "clippy"
          "rust-src"
          "rust-analyzer"
        ];
        targets = [
          "x86_64-unknown-linux-musl"
        ];
      })
      # Compiler cache
      pkgs.sccache
    ];

    home.sessionVariables = {
      # Rust mirror configuration (Tsinghua)
      RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup";
      RUSTUP_UPDATE_ROOT = "https://mirrors.tuna.tsinghua.edu.cn/rustup/update";

      # SCCACHE configuration
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      SCCACHE_CACHE_SIZE = "10G";
    };
  };
}
