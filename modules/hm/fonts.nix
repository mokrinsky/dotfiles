{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.yumi.fonts;
in {
  options.yumi.fonts.enable = mkEnableOption "Install fonts";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "JetBrainsMono"
        ];
      })
      ubuntu_font_family
      iosevka
    ];
  };
}
