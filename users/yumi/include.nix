{
  config,
  pkgs,
  inputs,
  ...
}: let
  linters = pkgs.fetchFromGitHub {
    owner = "mokrinsky";
    repo = "linters";
    rev = "8aaca06b126b2205acf014ee1d08a73331eef8a7";
    sha256 = "sha256-e29cmxw7Fkzj2+znYBcu2E4BEe4//Y12ABoLyqEXEbY=";
  };
in {
  imports = [
    ../../shared/apps/secure.nix
  ];
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
  sops = {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
    gnupg.home = config.programs.gpg.homedir;
    secrets = {
      wgPrivateKey = {
        sopsFile = "${inputs.self}/secrets/millia.yaml";
        path = "${config.xdg.configHome}/wgPrivateKey";
      };
    };
  };

  xdg.configFile = {
    "neofetch" = {
      source = "${inputs.self}/shared/configs/neofetch";
    };
    "btop/themes" = {
      source = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "btop";
        rev = "7109eac2884e9ca1dae431c0d7b8bc2a7ce54e54";
        sha256 = "sha256-QoPPx4AzxJMYo/prqmWD/CM7e5vn/ueyx+XQ5+YfHF8=";
      };
    };
    "linters" = {
      source = linters;
    };
    "yamlfmt/.yamlfmt" = {
      source = linters + "/.yamlfmt";
    };
    "${config.home.homeDirectory}/bin/vpnc-script" = {
      source = "${inputs.self}/shared/bin/vpnc-script";
    };
  };

  yumi = {
    brew.enable = true;
    darwin.enable = true;
    fish = {
      enable = true;
      withStarship = true;
      withGrc = true;
      withCatppuccin = true;
    };
    fonts.enable = true;
    git.enable = true;
    k8s.enable = true;
    neovim = {
      enable = true;
      withLazyVim = true;
      withSessionVariables = true;
    };
    nushell.enable = true;
    python = {
      enable = true;
      withAnsible = true;
    };
    sketchybar.enable = true;
    wezterm.enable = true;
    yabai = {
      enable = true;
      withSkhd = true;
    };
  };

  programs.java = {
    enable = true;
    package = pkgs.openjdk;
    installMaven = true;
    extraPackages = with pkgs; [
      openjdk17
      openjdk8
    ];
  };

  home = {
    inherit (config) username;
    stateVersion = "23.05";
    homeDirectory = "/Users/${config.username}";
    enableNixpkgsReleaseCheck = true;
    sessionVariables = {
      GOTELEMETRY = "off";
      EXA_ICON_SPACING = 2;
      TERMINFO_DIRS = "/Users/yumi/.terminfo";
    };

    language.base = "en_US.UTF-8";

    packages = with pkgs;
      [
        cacert
        inetutils
        ipcalc
        man-db
        mc
        minicom
        mtr
        neofetch
        nix-tree
        nmap
        p7zip
        rename
        sops
        pre-commit
        gum
        # rust replacements for some default console utilities
        cloak
        dogdns
        fzf
      ]
      ++ [
        # GNU utilities
        nur.repos.yumi.coreutils
        findutils
        gawk
        gnugrep
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
