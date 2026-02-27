{
  description = "Standalone Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      ...
    }:
    {
      _module.args.pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ rust-overlay.overlays.default ];
      };
      homeModules.nvim-config = [
        ./nix/rust.nix

        {
          imports = [ ];
          config = { pkgs, ... }: {
            home.packages =
              with pkgs;
              [
                gnumake
                ripgrep
                neovide
                zk
                choose

                biome
                tailwindcss
                astro-language-server
                prettier
                vscode-langservers-extracted
              ];

            xdg.configFile."nvim" = {
              source = "${self}";
              recursive = true;
            };

            programs.neovim = {
              enable = true;
              defaultEditor = true;
            };
          };
        }
      ];
    };
}
