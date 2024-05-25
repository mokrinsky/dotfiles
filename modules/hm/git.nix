{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.yumi.git;
in {
  options.yumi.git.enable = mkEnableOption "Install git configuration";

  config = mkIf cfg.enable {
    sops = {
      secrets = {
        gitconfigIncludes.path = "${config.home.homeDirectory}/.gitconfig.includes";
        gitconfigJob.path = "${config.home.homeDirectory}/.gitconfig.job";
      };
    };

    home.packages = with pkgs; [
      commitizen
    ];

    programs.git = {
      enable = true;
      userName = "Nikolay Mokrinsky";
      userEmail = "me@mokrinsky.ru";
      signing = {
        key = "EA54E892D96C779E1FA64E0A73CC011921471A15";
        signByDefault = true;
      };
      lfs = {
        enable = true;
      };
      extraConfig = {
        core = mkIf config.yumi.neovim.enable {
          editor = "nvim";
          pager = "nvim -R";
        };
        push = {
          autoSetupRemote = true;
        };
        color = {
          pager = "no";
        };
        status = {
          short = true;
          branch = true;
        };
      };
      includes = [
        {
          path = "~/.gitconfig.includes";
        }
      ];
      ignores = [
        "*.log"
        ".DS_Store"
        "*.swp"
        ".idea/"
        ".direnv/"
        ".envrc"
      ];
      hooks = {
        pre-commit = pkgs.writeShellScript "pre-commit" ''

          # start templated
          INSTALL_PYTHON=${pkgs.python3}/bin/python
          ARGS=(hook-impl --config=.pre-commit-config.yaml --hook-type=pre-commit --skip-on-missing-config)
          # end templated

          HERE="$(cd "$(dirname "$0")" && pwd)"
          ARGS+=(--hook-dir "$HERE" -- "$@")

          exec ${pkgs.pre-commit}/bin/pre-commit "''${ARGS[@]}"
        '';
      };
    };
  };
}
