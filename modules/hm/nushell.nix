{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.yumi.nushell;
in {
  options.yumi.nushell = {
    enable = mkEnableOption "Install fish shell config";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs = {
        nushell = {
          enable = true;
          shellAliases = {
            fetch = "neofetch";
            ls = "exa -alg --color=always --icons --group-directories-first --octal-permissions --no-permissions --git";
            cat = "bat --decorations never --paging never";
            dig = "dog";
            open = "^open";
            ps = "^ps";
          };
          extraConfig = ''
            use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
            # use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/man/man-completions.nu *
            use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu *
            # use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/yarn/yarn-completions.nu *
            use ${pkgs.nu_scripts}/share/nu_scripts/modules/kubernetes/kubernetes.nu *
            # use ${pkgs.nu_scripts}/share/nu_scripts/modules/ssh/ssh.nu *
            let-env PATH = ($env.PATH | split row (char esep) | append '${config.home.homeDirectory}/bin')
            let-env PATH = ($env.PATH | split row (char esep) | append '${config.home.homeDirectory}/go/bin')
            let-env PATH = ($env.PATH | split row (char esep) | append '${config.home.profileDirectory}/bin')
            let-env DIRENV_LOG_FORMAT = ""
            let-env GPG_TTY = (tty)
            let-env SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)
            def nuopen [arg, --raw (-r)] { if $raw { open -r $arg } else { open $arg } }

            gpgconf --launch gpg-agent
          '';
        };
      };
    })
  ];
}
