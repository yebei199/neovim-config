{
  description = "Standalone Neovim config";

  inputs = {
    nixpkgs.url = "nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ rust-overlay.overlays.default ];
      };
    in
    {
      homeModules.nvim-config = [
        ./nix/rust.nix
        ./nix/neovim.nix
      ];
    };
}
