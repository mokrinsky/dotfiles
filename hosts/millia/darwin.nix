{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [];

  users.users.${config.username} = {
    home = "/Users/${config.username}";
    shell = "${pkgs.fish}/bin/fish";
  };

  networking = let
    name = "millia";
  in {
    computerName = name;
    hostName = name;
    localHostName = name;
  };

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  environment = {
    shells = [pkgs.fish];
    variables = {
      JAVA_HOME = "/usr/local/Cellar/openjdk@17/17.0.6";
    };
  };

  system.stateVersion = 4;

  programs = {
    fish.enable = true;
  };

  # next line works fine, but MS Outlook cries each darwin-switch execution so i disabled it
  # time.timeZone = "Europe/Moscow";

  # TODO: reinstall applications so they will be managed by brew (aka by nix as well)
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      # upgrade = true;
    };
    global = {
      brewfile = true;
    };
    taps = ["homebrew/bundle" "homebrew/cask" "homebrew/core"];
    brews = [
      "squid"
      "openvpn"
      "openjdk@17"
      "maven"
    ];
    casks = [
      "alfred"
      # "apache-directory-studio"
      # "balenaetcher"
      "cyberduck"
      "discord"
      # "displaycal"
      "docker"
      # "lulu"
      # "mos"
      "notion"
      "sublime-text"
      "telegram-desktop"
      # "transmission"
      "tuntap"
      # "virtualbox"
      "visual-studio-code"
      "vlc"
      "wireshark"
      # "spotify"
    ];
    masApps = {
      "Microsoft Remote Desktop" = 1295203466;
      Xcode = 497799835;
      Pages = 409201541;
      Keynote = 409183694;
      Mattermost = 1614666244;
      "The Unarchiver" = 425424353;
      Numbers = 409203825;
    };
  };
}
