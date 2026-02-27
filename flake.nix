{
  description = "Standalone Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    homeModules.nvim-config = { pkgs, ... }: {
      home.packages = with pkgs; [
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
  };
}
