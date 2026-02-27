# Rust toolchain configuration with rust-overlay
# Provides: rustfmt, clippy, rust-src, rust-analyzer, and musl target
{ pkgs }:

let
  # Use rust-overlay's Rust package (latest stable from rust-overlay)
  rust = pkgs.rust-bin.stable.latest;
  
  # Extensions to include
  extensions = [
    "rustfmt"
    "clippy"
    "rust-src"
    "rust-analyzer"
  ];
  
  # Targets to support
  targets = [
    "x86_64-unknown-linux-musl"
  ];
  
  # Build the complete toolchain
  rustToolchain = rust.default.override {
    inherit extensions targets;
  };
  
in
{
  # Export the toolchain for use in home.packages
  toolchain = rustToolchain;
  
  # Export individual tools
  packages = {
    inherit (rust.default) cargo rustc rustfmt clippy;
    rust-analyzer = rust.default.rust-analyzer;
  };
  
  # Helper: return array of all tools for home.packages
  all = [
    rustToolchain
    pkgs.sccache
  ];
}