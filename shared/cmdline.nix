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
    };

    language.base = "en_US.UTF-8";

    packages = with pkgs;
      [
        config.nix.package
        kubectl
        nix-tree
        mc
        mtr
        nmap
        openssh
        openconnect
        minicom
        nodejs-16_x
        man-db
        # pulumi
        findutils
        gawk
        coreutils
        cacert
        p7zip
        rename
        # yt-dlp # need to make nix-shell cause I don't use it very often
        inetutils
        ripgrep
        gnugrep
        neofetch
        ipcalc
        starship
        virt-viewer
        (nerdfonts.override {
          fonts = [
            "NerdFontsSymbolsOnly"
          ];
        })
        ubuntu_font_family
        iosevka
        # rust replacements for some default console utilities
        exa
        procs
        grex
        cloak
        fd
        dogdns
        pkgs.nur.repos.yumi.fzf
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wireshark
        squid
        wezterm
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        darwin.iproute2mac
        yabai
        sketchybar
        pkgs.nur.repos.yumi.pidof
        pkgs.nur.repos.yumi.squid
      ];
  };

  programs = {
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
