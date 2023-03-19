{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  home = lib.mkIf isDarwin {
    packages = with pkgs; [
      sketchybar
      osx-cpu-temp
    ];
  };
  launchd = lib.mkIf isDarwin {
    agents.sketchybar = {
      enable = true;
      config = {
        ProgramArguments = ["${lib.getExe pkgs.sketchybar}"];
        KeepAlive = true;
        RunAtLoad = true;
        ProcessType = "Interactive";
        Nice = -20;
        StandardErrorPath = "${config.xdg.cacheHome}/sketchybar.log";
        StandardOutPath = "${config.xdg.cacheHome}/sketchybar.log";
        EnvironmentVariables = {
          LANG = "en_US.UTF-8";
          PATH = "${lib.makeBinPath [
            pkgs.sketchybar
            pkgs.bash
            pkgs.coreutils
            pkgs.yabai
            pkgs.jq
            pkgs.wireguard-tools
            pkgs.osx-cpu-temp
          ]}:/usr/bin:/usr/sbin";
        };
      };
    };
  };
  xdg.configFile = lib.mkIf isDarwin {
    "sketchybar" = {
      source = ./configs/sketchybar_config;
    };
  };
}
