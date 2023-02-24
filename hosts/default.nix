{systems, ...}:
with systems; [
  {
    hostname = "nixos";
    system = x86_64-linux;
    isNixOS = true;
    config = ./nixos;
  }

  {
    hostname = "millia";
    system = x86_64-darwin;
    isNixOS = false;
    config = ./millia;
  }
]
