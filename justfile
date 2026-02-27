set shell := ["fish", "-c"]
set dotenv-load := true
set export := true

check:
    nix flake check
    

