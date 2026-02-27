# Nix Configuration Rules

## 1. Validation Rules

- All changes must pass `nix flake check`
- If errors occur, fix them according to the error messages - do not ignore errors

## 2. File Organization Rules

- Reasonably decouple and split nix files
- Prohibit overly long files (recommended max 200 lines per file)
- Split configurations by functional modules

## 3. Comment Rules

- Use Chinese for comments
- Add explanatory comments at key parts
- Every file must have a comment on the first line describing its purpose

