{systems, ...}:
with systems; [
  {
    hostname = "nl";
    system = x86_64-linux;
    config = ./nl;
  }

  {
    hostname = "millia";
    system = x86_64-darwin;
    config = ./millia;
  }
]
