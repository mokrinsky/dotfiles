default:
  just -l

secret-stage:
  git add -f config/default.nix

secret-unstage:
  git restore --staged config/default.nix


[linux]
boot: secret-stage && secret-unstage
  sudo nixos-rebuild boot --flake .

[macos]
check:
  darwin-rebuild check --flake .

[linux]
check:
  sudo nixos-rebuild check --flake .

[macos]
switch: secret-stage && secret-unstage
  darwin-rebuild switch --flake .

[linux]
switch: secret-stage && secret-unstage
  sudo nixos-rebuild switch --flake .
