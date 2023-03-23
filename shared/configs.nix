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
    "neofetch" = {
      source = ./apps/configs/neofetch_config;
    };
    "procs" = {
      source = ./apps/configs/procs_config;
    };
    "wezterm/hyperlink.lua" = {
      source = ./apps/configs/wezterm_config/hyperlink.lua;
    };
    "wezterm/tabbar.lua" = {
      source = ./apps/configs/wezterm_config/tabbar.lua;
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
