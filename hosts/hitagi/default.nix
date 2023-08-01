{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../common
  ];

  users.users.${config.username} = {
    home = "/Users/${config.username}";
    shell = "${pkgs.fish}/bin/fish";
  };

  networking = let
    name = "hitagi";
  in {
    computerName = name;
    hostName = name;
    localHostName = name;
  };

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  environment = {
    shells = [
      pkgs.fish
      pkgs.nushell
    ];
  };

  system.stateVersion = 4;

  programs = {
    fish.enable = true;
  };

  # next line works fine, but MS Outlook cries each darwin-switch execution so i disabled it
  # time.timeZone = "Europe/Moscow";
}
