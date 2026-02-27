-- Rust language configuration
-- Uses rust-analyzer from system PATH (provided by Nix)

return {
  treesitter = true,
  lsp = "rust_analyzer",
  formatter = "rustfmt",
  pkgs = { "rust-analyzer", "rustfmt" },
}
