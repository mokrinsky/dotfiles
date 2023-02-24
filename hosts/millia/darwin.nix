{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [];

  users.users.yumi = {
    home = "/Users/yumi";
    shell = "${pkgs.fish}/bin/fish";
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      user = "root";
      options = "--delete-older-than 7d";
    };
  };

  services.nix-daemon.enable = true;

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

  # time.timeZone = "Europe/Moscow";

  homebrew = {
    enable = true;
    #cleanup = "zap";
    global = {
      brewfile = true;
    };
    taps = ["homebrew/bundle" "homebrew/cask" "homebrew/core"];
    brews = [
      "squid"
      "openvpn"
      "python@3.11"
      "openjdk@17"
      "maven"
    ];
    casks = [
      # "discord"
      "telegram-desktop"
      "visual-studio-code"
      "vlc"
      "docker"
      "sublime-text"
      "tuntap"
      "wezterm"
      "wireshark"
      # "cyberduck"
      # "notion"
      # "spotify"
    ];
    masApps = {};
  };
}
