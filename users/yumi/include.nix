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

  catppuccin = {
    accent = "peach";
    flavor = "mocha";
  };

  xdg.configFile = {
    "neofetch" = {
      source = "${inputs.self}/shared/configs/neofetch";
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
    };
    fonts.enable = true;
    git.enable = true;
    k8s.enable = true;
    neovim = {
      enable = true;
      withLazyVim = false;
      withSessionVariables = true;
    };
    python = {
      enable = true;
      withAnsible = true;
    };
    secure.enable = true;
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
      openjdk21
      openjdk17
      openjdk8
    ];
  };

  home = {
    stateVersion = "23.05";
    homeDirectory = "/Users/yumi";
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
        sshpass
      ]
      ++ [
        # GNU utilities
        findutils
        gawk
        gnugrep
        curl
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wireshark
        squid
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        darwin.iproute2mac
      ];
  };

  programs = {
    eza.enable = true;
    go = {
      enable = true;
      goPath = "go";
      goBin = "go/bin";
    };
    man = {
      enable = true;
      generateCaches = true;
    };
    htop.enable = true;
    home-manager.enable = true;
    jq.enable = true;
  };
}
