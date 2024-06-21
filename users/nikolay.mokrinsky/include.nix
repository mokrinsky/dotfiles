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
  # imports = [
  #   ../../shared/apps/secure.nix
  # ];

  sops = {
    defaultSopsFile = "${inputs.self}/secrets/secrets.yaml";
    gnupg.home = config.programs.gpg.homedir;
  };

  catppuccin = {
    accent = "peach";
    flavor = "mocha";
  };

  xdg.configFile = {
    "linters" = {
      source = linters;
    };
    "yamlfmt/.yamlfmt" = {
      source = linters + "/.yamlfmt";
    };
  };

  yumi = {
    darwin.enable = true;
    fish = {
      enable = true;
      withStarship = true;
      withGrc = true;
    };
    fonts.enable = true;
    git.enable = true;
    neovim = {
      enable = true;
      withLazyVim = false;
      withSessionVariables = true;
    };
    wezterm.enable = true;
  };

  home = {
    stateVersion = "24.05";
    homeDirectory = "/Users/nikolay.mokrinsky";
    enableNixpkgsReleaseCheck = true;
    sessionVariables = {
      GOTELEMETRY = "off";
      EXA_ICON_SPACING = 2;
      TERMINFO_DIRS = "/Users/nikolay.mokrinsky/.terminfo";
    };

    language.base = "en_US.UTF-8";

    packages = with pkgs;
      [
        cacert
        inetutils
        ipcalc
        man-db
        mc
        mtr
        nix-tree
        nmap
        p7zip
        sops
        pre-commit
        # rust replacements for some default console utilities
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
    man = {
      enable = true;
      generateCaches = true;
    };
    htop.enable = true;
    home-manager.enable = true;
    jq.enable = true;
  };
}
