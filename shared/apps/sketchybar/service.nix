{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
  lib.mkIf isDarwin {
    launchd.agents.sketchybar.config.EnvironmentVariables = {
      LANG = "en_US.UTF-8";
    };

    services.sketchybar = {
      enable = true;
      logFile = "${config.xdg.cacheHome}/sketchybar.log";
      extraPackages = with pkgs; [
        yabai
        jq
        osx-cpu-temp
        wireguard-tools
      ];
    };
  }
