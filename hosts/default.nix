{systems, ...}:
with systems; [
  {
    hostname = "nixos";
    system = x86_64-linux;
    config = ./nixos;
  }

  {
    hostname = "millia";
    system = x86_64-darwin;
    config = ./millia;
  }
]
