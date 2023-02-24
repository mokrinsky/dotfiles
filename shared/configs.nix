{
  config,
  pkgs,
  ...
}: let
  linters = pkgs.fetchFromGitHub {
    owner = "mokrinsky";
    repo = "linters";
    rev = "HEAD";
    sha256 = "sha256-uzlL2dxJr9TNCTzgf8REc+ytpNEYX4QjCckIuGiVCy8=";
  };
in {
  xdg.configFile = {
    "starship.toml" = {
      source = ./apps/configs/starship_config/starship.toml;
    };
    "neofetch" = {
      source = ./apps/configs/neofetch_config;
    };
    "procs" = {
      source = ./apps/configs/procs_config;
    };
    "wezterm" = {
      source = ./apps/configs/wezterm_config;
    };
    "linters" = {
      source = linters;
    };
    "yamlfmt/.yamlfmt" = {
      source = linters + "/.yamlfmt";
    };
    # There must be a better way to create something under home directory :D
    "../bin/vpnc-script" = {
      source = ./bin/vpnc-script;
    };
  };
}
