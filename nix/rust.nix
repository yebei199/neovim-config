# nix/rust.nix - Rust toolchain and environment as home-manager module
# 将 Rust 工具链配置和环境变量作为 home-manager 模块导出
# 包含：完整工具链、SCCACHE、mold 链接器、cargo 配置
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
      pkgs.clang
      pkgs.trunk
      pkgs.mold
      pkgs.cargo-sweep
      pkgs.musl
      pkgs.musl.dev
    ];

    home.sessionVariables = {
      # Rust mirror configuration (Tsinghua)
      RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup";
      RUSTUP_UPDATE_ROOT = "https://mirrors.tuna.tsinghua.edu.cn/rustup/update";

      # SCCACHE configuration
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      SCCACHE_CACHE_SIZE = "8G";
    };

    home.file.".cargo/config.toml".text = ''
      [build]
        rustc-wrapper = "${pkgs.sccache}/bin/sccache"

      [target.x86_64-unknown-linux-gnu]
        linker = "${pkgs.clang}/bin/clang"
        rustflags = ["-C", "link-arg=-fuse-ld=mold"]

      [target.wasm32-unknown-unknown]
        rustflags = ['--cfg', 'getrandom_backend="wasm_js"']

      [registries]
        tuna = { index = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git" }

      [registry]
        default = "tuna"

      [net]
      git-fetch-with-cli = true
    '';
  };
}
