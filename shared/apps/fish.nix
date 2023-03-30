{
  config,
  pkgs,
  lib,
  configRoot,
  inputs,
  ...
}: let
  flavor = "mocha";
  ctp = inputs.catppuccin.${flavor};
  unsharp = lib.strings.removePrefix "#";
in {
  xdg.configFile."fish/themes/theme.theme" = {
    text = ''
      fish_color_normal ${unsharp ctp.text.hex}
      fish_color_command ${unsharp ctp.blue.hex}
      fish_color_param ${unsharp ctp.flamingo.hex}
      fish_color_keyword ${unsharp ctp.red.hex}
      fish_color_quote ${unsharp ctp.green.hex}
      fish_color_redirection ${unsharp ctp.pink.hex}
      fish_color_end ${unsharp ctp.peach.hex}
      fish_color_comment ${unsharp ctp.overlay1.hex}
      fish_color_error ${unsharp ctp.red.hex}
      fish_color_gray ${unsharp ctp.overlay0.hex}
      fish_color_selection --background=${unsharp ctp.surface0.hex}
      fish_color_search_match --background=${unsharp ctp.surface0.hex}
      fish_color_operator ${unsharp ctp.pink.hex}
      fish_color_escape ${unsharp ctp.maroon.hex}
      fish_color_autosuggestion ${unsharp ctp.overlay0.hex}
      fish_color_cancel ${unsharp ctp.red.hex}
      fish_color_cwd ${unsharp ctp.yellow.hex}
      fish_color_user ${unsharp ctp.teal.hex}
      fish_color_host ${unsharp ctp.blue.hex}
      fish_color_host_remote ${unsharp ctp.green.hex}
      fish_color_status ${unsharp ctp.red.hex}
      fish_pager_color_progress ${unsharp ctp.overlay0.hex}
      fish_pager_color_prefix ${unsharp ctp.pink.hex}
      fish_pager_color_completion ${unsharp ctp.text.hex}
      fish_pager_color_description ${unsharp ctp.overlay0.hex}
    '';
  };

  programs = {
    starship = {
      enable = true;
      settings = {
        palettes.ctp = {
          rosewater = ctp.rosewater.hex;
          flamingo = ctp.flamingo.hex;
          pink = ctp.pink.hex;
          mauve = ctp.mauve.hex;
          red = ctp.red.hex;
          maroon = ctp.maroon.hex;
          peach = ctp.peach.hex;
          yellow = ctp.yellow.hex;
          green = ctp.green.hex;
          teal = ctp.teal.hex;
          sky = ctp.sky.hex;
          sapphire = ctp.sapphire.hex;
          blue = ctp.blue.hex;
          lavender = ctp.lavender.hex;
          text = ctp.text.hex;
          subtext1 = ctp.subtext1.hex;
          subtext0 = ctp.subtext0.hex;
          overlay2 = ctp.overlay2.hex;
          overlay1 = ctp.overlay1.hex;
          overlay0 = ctp.overlay0.hex;
          surface2 = ctp.surface2.hex;
          surface1 = ctp.surface1.hex;
          surface0 = ctp.surface0.hex;
          base = ctp.base.hex;
          mantle = ctp.mantle.hex;
          crust = ctp.crust.hex;
        };
        palette = "ctp";
        format = "$golang$java$kotlin$nodejs$rust$python$docker_context$kubernetes$cmd_duration$git_branch$git_status\n$directory$character";
        right_format = "";
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[x](bold red)";
          vimcmd_symbol = "[<](bold green)";
        };
        directory = {
          format = "[ $path ]($style)";
          truncation_length = 1;
          fish_style_pwd_dir_length = 1;
        };
        docker_context = {
          symbol = " ";
          style = "bg:teal fg:base";
          format = "[ $symbol $context ]($style) $path";
        };
        golang = {
          symbol = " ";
          format = "(fg:base bg:base)[](fg:blue bg:base)[$symbol$version](fg:base bg:blue)[](fg:blue bg:none) ";
          style = "fg:blue bg:base";
        };
        java = {
          symbol = " ";
          style = "fg:mauve bg:base";
          format = "(fg:base bg:base)[](fg:mauve bg:base)[$symbol$version](fg:base bg:mauve)[](fg:mauve bg:none) ";
        };
        kotlin = {
          symbol = " ";
          style = "fg:mauve bg:base";
          format = "(fg:base bg:base)[](fg:mauve bg:base)[$symbol$version](fg:base bg:mauve)[](fg:mauve bg:none) ";
        };
        nodejs = {
          symbol = " ";
          style = "fg:sky bg:base";
          format = "(fg:base bg:base)[](fg:sky bg:base)[$symbol$version](fg:base bg:sky)[](fg:sky bg:none) ";
        };
        rust = {
          format = "(fg:base bg:base)[](fg:red bg:base)[$symbol$version](fg:base bg:red)[](fg:red bg:none) ";
          style = "fg:red bg:base";
          symbol = " ";
        };
        kubernetes = {
          symbol = "󱃾 ";
          format = "(fg:base bg:base)[](fg:sapphire bg:base)[$symbol$context](fg:base bg:sapphire)[](fg:sapphire bg:none) ";
          style = "fg:sapphire bg:base";
          disabled = false;
        };
        git_branch = {
          format = "(fg:base bg:base)[](fg:yellow bg:base)[ $branch](fg:base bg:yellow)[](fg:yellow bg:none) ";
          style = "fg:yellow bg:base";
        };
        git_status = {
          format = "(fg:base bg:base)[](fg:lavender bg:base)[$all_status](fg:base bg:lavender)[](fg:lavender bg:none) ";
          style = "fg:lavender bg:base";
          conflicted = "=";
          ahead = " $count";
          behind = " $count";
          diverged = " $ahead_count$behind_count";
          up_to_date = " ";
          untracked = "?$count";
          stashed = " ";
          modified = "!$count";
          staged = "+$count";
          renamed = "»$count";
          deleted = "✘$count";
        };
        python = {
          format = "(fg:base bg:base)[](fg:green bg:base)[$symbol$pyenv_prefix($version )($virtualenv )](fg:base bg:green)[](fg:green bg:none) ";
          style = "fg:green bg:base";
          symbol = " ";
        };
        cmd_duration = {
          min_time = 1;
          format = "(fg:base bg:base)[](fg:mauve bg:base)[ $duration](fg:base bg:mauve)[](fg:mauve bg:none) ";
          disabled = false;
          style = "fg:mauve bg:base";
        };
      };
    };
    fish = {
      enable = true;
      shellAliases = {
        # neofetch = "neofetch --ascii ${config.home.homeDirectory}/.config/neofetch/megurine.ascii --gap -670";
        ls = "exa -alg --color=always --icons --group-directories-first --octal-permissions --no-permissions --git";
        cat = "bat --decorations never --paging never";
        ps = "procs";
        dig = "dog";
        lazyvim = "env NVIM_APPNAME=lazyvim nvim";
      };
      shellInit = ''
        echo y | fish_config theme save theme

        set -Ux fish_user_paths
        fish_add_path ${config.home.homeDirectory}/bin
        fish_add_path ${config.home.homeDirectory}/go/bin
        fish_add_path ${config.home.profileDirectory}/bin

        set -Ua fish_features ampersand-nobg-in-token qmark-noglob
        set -x GPG_TTY (tty)
        set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent
      '';
      plugins = [
        {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "v9.5";
            sha256 = "ZdHfIZNCtY36IppnufEIyHr+eqlvsIUOs0kY5I9Df6A=";
          };
        }
      ];
    };
  };
}
