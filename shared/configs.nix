{
  config,
  pkgs,
  ...
}: let
  linters = pkgs.fetchFromGitHub {
    owner = "mokrinsky";
    repo = "linters";
    rev = "8aaca06b126b2205acf014ee1d08a73331eef8a7";
    sha256 = "sha256-e29cmxw7Fkzj2+znYBcu2E4BEe4//Y12ABoLyqEXEbY=";
  };
in {
  xdg.configFile = {
    "neofetch" = {
      source = ./apps/configs/neofetch_config;
    };
    "btop/themes" = {
      source = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "btop";
        rev = "HEAD";
        sha256 = "sha256-ovVtupO5jWUw6cwA3xEzRe1juUB8ykfarMRVTglx3mk=";
      };
    };
    "linters" = {
      source = linters;
    };
    "yamlfmt/.yamlfmt" = {
      source = linters + "/.yamlfmt";
    };
    "${config.home.homeDirectory}/bin/vpnc-script" = {
      source = ./bin/vpnc-script;
    };
  };
}
