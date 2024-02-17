{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.yumi.sketchybar;
in {
  options.yumi.sketchybar.enable = mkEnableOption "Enable sketchybar";
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isDarwin;
        message =
          "This module is available only for darwin platform. If you run linux, please, set"
          + "yumi.sketchybar.enable = false; in your configuration";
      }
    ];

    launchd.agents.sketchybar.config.EnvironmentVariables = {
      LANG = "en_US.UTF-8";
    };

    services.sketchybar = {
      enable = true;
      logFile = "${config.xdg.cacheHome}/sketchybar.log";
      extraPackages = with pkgs; [
        yabai
        jq
        wireguard-tools
      ];
    };
  };
}
