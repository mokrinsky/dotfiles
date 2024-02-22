{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.yumi.brew;
in {
  options.yumi.brew.enable = mkEnableOption "Install utilities with homebrew";

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isDarwin;
        message =
          "This module is available only for darwin platform. If you run linux, please, set"
          + "yumi.brew.enable = false; in your configuration";
      }
    ];

    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        silent = true;
        # upgrade = true;
      };
      global = {
        brewfile = true;
      };
      taps = ["homebrew/bundle"];
      brews = [
      ];
      casks = [
        # "apache-directory-studio"
        "arc"
        # "balenaetcher"
        "cyberduck"
        "discord"
        # "displaycal"
        "docker"
        "iina"
        "keepassxc"
        # "mos"
        "notion"
        "obsidian"
        "raycast"
        "robo-3t"
        "sublime-text"
        "telegram-desktop"
        # "transmission"
        # "tuntap"
        # "virtualbox"
        "visual-studio-code"
        "vlc"
        "wezterm"
        "wireshark"
        "spotify"
      ];
      masApps = {
        "Microsoft Remote Desktop" = 1295203466;
        Xcode = 497799835;
        Pages = 409201541;
        Keynote = 409183694;
        Mattermost = 1614666244;
        "The Unarchiver" = 425424353;
        Numbers = 409203825;
        Slack = 803453959;
      };
    };
  };
}
