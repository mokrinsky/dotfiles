{
  config,
  pkgs,
  lib,
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

  home.packages = with pkgs; [
    grc
    fishPlugins.grc
  ];

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
        format = "[](fg:red)$username$hostname$container$sudo$shlvl[](fg:red bg:peach)$git_branch$git_commit$git_state$git_status$git_metrics[](fg:peach bg:yellow)$cmd_duration[](fg:yellow bg:green)$java$kotlin$golang$helm$nodejs$python$rust[](fg:green bg:blue)$package$nix_shell[](fg:blue bg:mauve)$docker_context$kubernetes[](fg:mauve)$line_break$directory$shell$status$character";
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
          format = "[ $symbol$version ]($style)";
          style = "fg:base bg:green";
        };
        helm = {
          symbol = "󰶓 ";
          format = "[ $symbol$version ]($style)";
          style = "fg:base bg:green";
        };
        java = {
          symbol = " ";
          style = "fg:base bg:green";
          format = "[ $symbol$version ]($style)";
        };
        kotlin = {
          symbol = " ";
          style = "fg:base bg:green";
          format = "[ $symbol$version ]($style)";
        };
        nodejs = {
          symbol = " ";
          style = "fg:base bg:green";
          format = "[ $symbol$version ]($style)";
        };
        rust = {
          format = "[ $symbol$version ]($style)";
          style = "fg:base bg:green";
          symbol = " ";
        };
        python = {
          format = "[ $symbol$pyenv_prefix($version)($virtualenv) ]($style)";
          style = "fg:base bg:green";
          symbol = " ";
        };
        package = {
          symbol = " ";
          style = "fg:base bg:blue";
          format = "[ $symbol$version ]($style)";
        };
        kubernetes = {
          symbol = "󱃾 ";
          format = "[ $symbol$context ]($style)";
          style = "fg:base bg:mauve";
          disabled = false;
        };
        nix_shell = {
          symbol = " ";
          format = "[ $symbol$state( \\($name\\)) ]($style)";
          style = "fg:base bg:blue";
        };
        git_branch = {
          symbol = " ";
          format = "[ $symbol$branch ]($style)";
          style = "fg:base bg:peach";
        };
        git_status = {
          format = "[$all_status ]($style)";
          style = "fg:base bg:peach";
          conflicted = "=";
          ahead = " $count";
          behind = " $count";
          diverged = " $ahead_count $behind_count";
          up_to_date = " ";
          untracked = "?$count";
          stashed = " ";
          modified = "!$count";
          staged = "+$count";
          renamed = "»$count";
          deleted = "✘$count";
        };
        cmd_duration = {
          min_time = 1;
          format = "[  $duration ]($style)";
          disabled = false;
          style = "fg:base bg:yellow";
        };
        status = {
          disabled = false;
          format = "[$status ]($style)";
        };
      };
    };
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    fish = {
      enable = true;
      shellAliases = {
        fetch = "neofetch";
        ls = "exa -alg --color=always --icons --group-directories-first --octal-permissions --no-permissions --git";
        cat = "bat --decorations never --paging never";
        dig = "dog";
        lazyvim = "NVIM_APPNAME=lazyvim nvim";
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
