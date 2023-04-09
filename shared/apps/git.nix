{
  pkgs,
  configRoot,
  ...
}: {
  programs.git = {
    enable = true;
    userName = configRoot.name;
    userEmail = configRoot.email;
    signing = {
      key = configRoot.gpgKey;
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
    includes = configRoot.gitIncludes;
    hooks = {
      prepare-commit-msg = pkgs.writeShellScript "prepare-commit-msg" ''

        COMMIT_MSG_FILE=$1
        COMMIT_SOURCE=$2
        SHA1=$3

        SOB=$'# Recommended-commit-format:\n# (fix|feat|build|chore|ci|docs|style|refactor|perf|test|BREAKING CHANGE): Commit message\n#'
        git interpret-trailers --in-place --trailer "$SOB" "$COMMIT_MSG_FILE"
        if test -z "$COMMIT_SOURCE"
        then
          ${pkgs.perl}/bin/perl -i.bak -pe 'print "\n" if !$first_line++' "$COMMIT_MSG_FILE"
        fi
      '';
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
