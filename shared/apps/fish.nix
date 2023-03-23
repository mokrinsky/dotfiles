{
  config,
  pkgs,
  lib,
  configRoot,
  inputs,
  ...
}: let
  ctp = inputs.catppuccin;
  flavor = "mocha";
in {
  home.activation = lib.mkIf (configRoot.username != "root") {
    # TODO: bat can fetch them with nix function. Maybe I should write PR so fish could do that as well...
    executeCustomScripts = config.lib.dag.entryAfter ["linkGeneration"] ''
      echo ":: Getting fish theme..."
      mkdir -p ${config.home.homeDirectory}/.config/fish/themes
      curl https://raw.githubusercontent.com/catppuccin/fish/main/themes/Catppuccin%20Mocha.theme -o ${config.home.homeDirectory}/.config/fish/themes/mocha.theme &> /dev/null
    '';
  };

  programs = {
    starship = {
      enable = true;
      settings = {
        palettes.ctp = {
          rosewater = ctp.${flavor}.rosewater.hex;
          flamingo = ctp.${flavor}.flamingo.hex;
          pink = ctp.${flavor}.pink.hex;
          mauve = ctp.${flavor}.mauve.hex;
          red = ctp.${flavor}.red.hex;
          maroon = ctp.${flavor}.maroon.hex;
          peach = ctp.${flavor}.peach.hex;
          yellow = ctp.${flavor}.yellow.hex;
          green = ctp.${flavor}.green.hex;
          teal = ctp.${flavor}.teal.hex;
          sky = ctp.${flavor}.sky.hex;
          sapphire = ctp.${flavor}.sapphire.hex;
          blue = ctp.${flavor}.blue.hex;
          lavender = ctp.${flavor}.lavender.hex;
          text = ctp.${flavor}.text.hex;
          subtext1 = ctp.${flavor}.subtext1.hex;
          subtext0 = ctp.${flavor}.subtext0.hex;
          overlay2 = ctp.${flavor}.overlay2.hex;
          overlay1 = ctp.${flavor}.overlay1.hex;
          overlay0 = ctp.${flavor}.overlay0.hex;
          surface2 = ctp.${flavor}.surface2.hex;
          surface1 = ctp.${flavor}.surface1.hex;
          surface0 = ctp.${flavor}.surface0.hex;
          base = ctp.${flavor}.base.hex;
          mantle = ctp.${flavor}.mantle.hex;
          crust = ctp.${flavor}.crust.hex;
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
      };
      shellInit = ''
        echo y | fish_config theme save mocha

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
