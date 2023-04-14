{
  pkgs,
  config,
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
      FZF_DEFAULT_OPTS = "--cycle --border --height=90% --preview-window=wrap --marker=\"*\"";
      EXA_ICON_SPACING = 2;
      TERMINFO_DIRS = "/Users/yumi/.terminfo";
      ANSIBLE_CONFIG = "${config.xdg.configHome}/ansible.cfg";
      JAVA_HOME = "/usr/local/Cellar/openjdk@17/17.0.6";
    };

    language.base = "en_US.UTF-8";

    packages = with pkgs;
      [
        config.nix.package
        home-manager
        cacert
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
        p7zip
        rename
        ripgrep
        virt-viewer
        pre-commit
        # rust replacements for some default console utilities
        grex
        cloak
        fd
        dogdns
        just
        nur.repos.yumi.fzf
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wireshark
        squid
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        darwin.iproute2mac
        nur.repos.yumi.pidof
        nur.repos.yumi.squid
      ];
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      silent = true;
      # upgrade = true;
    };
    global = {
      brewfile = true;
    };
    taps = ["homebrew/bundle" "homebrew/cask" "homebrew/core"];
    brews = [
      "squid"
      "openjdk@17"
      "maven"
    ];
    casks = [
      "alfred"
      # "apache-directory-studio"
      # "balenaetcher"
      "cyberduck"
      "discord"
      # "displaycal"
      "docker"
      # "lulu"
      # "mos"
      "notion"
      "sublime-text"
      "telegram-desktop"
      # "transmission"
      "tuntap"
      # "virtualbox"
      "visual-studio-code"
      "vlc"
      "wireshark"
      # "spotify"
    ];
    masApps = {
      "Microsoft Remote Desktop" = 1295203466;
      Xcode = 497799835;
      Pages = 409201541;
      Keynote = 409183694;
      Mattermost = 1614666244;
      "The Unarchiver" = 425424353;
      Numbers = 409203825;
    };
  };

  programs = {
    exa.enable = true;
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
  };
}
