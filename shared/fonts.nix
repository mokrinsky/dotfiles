{
  pkgs,
  config,
  inputs,
  system,
  lib,
  ...
}: {
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
}
