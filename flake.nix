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
      homeModules.nvim-config =
        { pkgs, ... }:
        let
          rustConfig = import ./nix/rust.nix { inherit pkgs; };
        in
        {
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

            ]
            ++ rustConfig.all;

          xdg.configFile."nvim" = {
            source = "${self}";
            recursive = true;
          };

          programs.neovim = {
            enable = true;
            defaultEditor = true;
          };

          home.sessionVariables = {
            # Rust mirror configuration (Tsinghua)
            RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup";
            RUSTUP_UPDATE_ROOT = "https://mirrors.tuna.tsinghua.edu.cn/rustup/update";

            # SCCACHE configuration
            RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
            SCCACHE_CACHE_SIZE = "10G";
          };
        };
    };
}
