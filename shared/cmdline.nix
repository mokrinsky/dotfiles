{
  pkgs,
  config,
  inputs,
  system,
  lib,
  ...
}: {
  # launchd = {
  #   enable = true;
  #   agents = {
  #     squid = {
  #       enable = true;
  #       config = {
  #         KeepAlive = true;
  #         Label = "yumi.nix.squid";
  #         RunAtLoad = true;
  #         ProgramArguments = [
  #           "squid"
  #           "-N"
  #           "-d 1"
  #         ];
  #         WorkingDirectory = "/usr/local/var";
  #       };
  #     };
  #   };
  # };

  home = {
    enableNixpkgsReleaseCheck = true;
    sessionVariables = {
      GOTELEMETRY = "off";
      VISUAL = "$EDITOR";
      SUDO_EDITOR = "$EDITOR";
      FZF_DEFAULT_OPTS = "--cycle --border --height=90% --preview-window=wrap --marker=\"*\"";
      EXA_ICON_SPACING = 2;
      TERMINFO_DIRS = "/Users/yumi/.terminfo";
    };

    language.base = "en_US.UTF-8";

    packages = with pkgs;
      [
        config.nix.package
        cacert
        coreutils
        findutils
        gawk
        gnugrep
        gopass
        inetutils
        ipcalc
        kubectl
        man-db
        mc
        minicom
        mtr
        neofetch
        nix-tree
        nmap
        openconnect
        p7zip
        rename
        ripgrep
        virt-viewer
        yubikey-manager
        # rust replacements for some default console utilities
        procs
        grex
        cloak
        fd
        dogdns
        just
        pkgs.nur.repos.yumi.fzf
        # python stuff
        (python3.withPackages (p:
          with p; [
            pip
            numpy
            yt-dlp
            black
            ansible-lint
            pylint
            yamllint
            ansible
          ]))
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wireshark
        squid
        wezterm
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        darwin.iproute2mac
        pkgs.nur.repos.yumi.pidof
        pkgs.nur.repos.yumi.squid
      ];
  };

  programs = {
    exa.enable = true;
    ssh = {
      enable = true;
      serverAliveInterval = 15;
      includes = [
        "config_job"
        "config_personal"
        "config_f5"
      ];
      matchBlocks = {
        "*" = {
          remoteForwards = [
            {
              bind.port = 3128;
              host.address = "127.0.0.1";
              host.port = 3128;
            }
          ];
          extraOptions = {
            PubkeyAcceptedKeyTypes = "+ssh-rsa,ssh-dss";
          };
        };
      };
    };
    go = {
      enable = true;
      goPath = "go";
      goBin = "go/bin";
    };
    man = {
      enable = true;
      generateCaches = true;
    };
    bat = {
      enable = true;
      config = {
        theme = "mocha";
      };
      themes = {
        mocha = builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "bat";
            rev = "main";
            sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          }
          + "/Catppuccin-mocha.tmTheme");
      };
    };
    htop.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    gpg = {
      enable = true;
      homedir = config.xdg.configHome + "/gnupg";
      settings = {
        no-emit-version = true;
        no-greeting = true;
      };
    };
  };
}
