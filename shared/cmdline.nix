{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  mkalias = inputs.mkAlias.outputs.apps.${pkgs.system}.default.program;
in {
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
  disabledModules = ["targets/darwin/linkapps.nix"]; # to use my aliasing instead
  home.activation.aliasApplications = lib.mkIf pkgs.stdenv.isDarwin (
    let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in
      lib.hm.dag.entryAfter ["linkGeneration"] ''
        echo "Linking Home Manager applications..." 2>&1
        app_path="$HOME/Applications/Home Manager Apps"
        tmp_path="$(mktemp -dt "home-manager-applications.XXXXXXXXXX")" || exit 1
        ${pkgs.fd}/bin/fd \
        	-t l -d 1 . ${apps}/Applications \
        	-x $DRY_RUN_CMD ${mkalias} -L {} "$tmp_path/{/}"
        $DRY_RUN_CMD rm -rf "$app_path"
        $DRY_RUN_CMD mv "$tmp_path" "$app_path"
      ''
  );
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
        nur.repos.yumi.coreutils
        findutils
        gawk
        gnugrep
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
        procs
        grex
        cloak
        fd
        dogdns
        just
        nur.repos.yumi.fzf
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
            virtualenv
            pika
            nur.repos.yumi.ovirt-engine-sdk-python
          ]))
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
    wezterm = {
      enable = true;
      package = pkgs.nur.repos.nekowinston.wezterm-nightly;
      extraConfig = ''
        local hyperlink = require 'hyperlink'
        require 'tabbar'

        return {
          adjust_window_size_when_changing_font_size = false,
          allow_square_glyphs_to_overflow_width = 'Always',
          audible_bell = 'Disabled',
          automatically_reload_config = true,
          color_scheme = 'Catppuccin Mocha', -- or Macchiato, Frappe, Latte
          colors = {
            tab_bar = {
              background = 'rgba(30, 30, 46, 0.3)',
            },
          },
          debug_key_events = false,
          enable_scroll_bar = false,
          font = wezterm.font_with_fallback {
            {
              family = 'Berkeley Mono',
              harfbuzz_features = { 'calt=0', 'clig=1', 'liga=1' },
            },
          },
          font_size = 12,
          hide_tab_bar_if_only_one_tab = true,
          hyperlink_rules = hyperlink,
          scrollback_lines = 10000,
          swallow_mouse_click_on_window_focus = false,
          tab_bar_style = {
            new_tab = "",
            new_tab_hover = "",
          },
          tab_max_width = 32,
          use_fancy_tab_bar = false,
          use_ime = false,
          window_background_opacity = 0.7,
          window_decorations = 'RESIZE',
          window_padding = {
            bottom = 0,
            left = 5,
            right = 5,
            top = 0,
          },
        }
      '';
    };
  };
}
