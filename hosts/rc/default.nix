{pkgs, ...}: {
  imports = [
    ../common
  ];

  users.users."nikolay.mokrinsky" = {
    home = "/Users/nikolay.mokrinsky";
    shell = "${pkgs.fish}/bin/fish";
  };

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  environment = {
    shells = [
      pkgs.fish
    ];
  };

  system.stateVersion = 4;

  programs = {
    fish.enable = true;
  };
}
