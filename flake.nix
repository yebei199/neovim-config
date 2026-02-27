{
  description = "Standalone Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazy-nvim = {
      url = "github:folke/lazy.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, rust-overlay, lazy-nvim, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ rust-overlay.overlays.default ];
      };
    in
    {
      homeModules.nvim-config = [
        {
          imports = [
            ./nix/rust.nix
            ./nix/neovim.nix
          ];
          _module.args = {
            nvim_config_src = self;
            lazy-nvim = lazy-nvim;
          };
        }
      ];
    };
}
