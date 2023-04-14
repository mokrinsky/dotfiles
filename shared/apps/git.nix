{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    commitizen
  ];

  programs.git = {
    enable = true;
    userName = config.name;
    userEmail = config.email;
    signing = {
      key = config.gpgKey;
      signByDefault = true;
    };
    lfs = {
      enable = true;
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      push = {
        autoSetupRemote = true;
      };
    };
    includes = config.gitIncludes;
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
}
