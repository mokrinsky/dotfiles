{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.yumi.fish;
in {
  options.yumi.fish = {
    enable = mkEnableOption "Install fish shell config";
    withStarship = mkEnableOption "Install starship config";
    withGrc = mkEnableOption "Install grc for fish";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs = {
        atuin = {
          enable = true;
          flags = ["--disable-up-arrow"];
        };
        bat = {
          enable = true;
          catppuccin.enable = true;
        };
        direnv.enable = true;
        direnv.nix-direnv.enable = true;
        fish = {
          enable = true;
          catppuccin = {
            enable = true;
            flavor = "mocha";
          };
          shellAliases = {
            fetch = "neofetch";
            ls = "eza -alg --color=always --icons --group-directories-first --octal-permissions --no-permissions --git";
            cat = "bat --decorations never --paging never";
            dig = "dog";
            diff = "delta";
          };
          shellInit = ''
            set -Ux fish_user_paths
            fish_add_path ${config.home.homeDirectory}/bin
            fish_add_path ${config.home.homeDirectory}/go/bin
            fish_add_path ${config.home.profileDirectory}/bin
            fish_add_path /opt/homebrew/bin
            fish_add_path /opt/homebrew/sbin

            set -Ua fish_features ampersand-nobg-in-token qmark-noglob
            set -x DIRENV_LOG_FORMAT ""
            set -x GPG_TTY (tty)
            set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
            gpgconf --launch gpg-agent
          '';
        };
        zoxide = {
          enable = true;
          options = ["--cmd cd"];
        };
      };
    })

    (mkIf (cfg.enable && cfg.withGrc) {
      home.packages = with pkgs; [
        grc
        fishPlugins.grc
      ];
    })

    (mkIf (cfg.enable && cfg.withStarship) {
      programs = {
        starship = {
          enable = true;
          catppuccin = {
            enable = true;
            flavor = "mocha";
          };
          settings = {
            format = "$git_branch$git_commit$git_state$git_status$git_metrics$java$kotlin$golang$helm$nodejs$python$package$nix_shell$docker_context$kubernetes$line_break$directory$shell$status$character";
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
            };
            helm = {
              symbol = "󰶓 ";
              format = "[ $symbol$version ]($style)";
            };
            java = {
              symbol = " ";
              format = "[ $symbol$version ]($style)";
            };
            kotlin = {
              symbol = " ";
              format = "[ $symbol$version ]($style)";
            };
            nodejs = {
              symbol = " ";
              format = "[ $symbol$version ]($style)";
            };
            python = {
              format = "[ $symbol$pyenv_prefix($version)($virtualenv) ]($style)";
              symbol = "󰌠 ";
            };
            package = {
              symbol = " ";
              format = "[ $symbol$version ]($style)";
            };
            kubernetes = {
              symbol = "󱃾 ";
              format = "[ $symbol$context ]($style)";
              disabled = false;
            };
            nix_shell = {
              symbol = " ";
              format = "[ $symbol$state( \\($name\\)) ]($style)";
            };
            git_branch = {
              symbol = " ";
              format = "[$symbol$branch(:$remote_branch)]($style) ";
            };
            git_status = {
              conflicted = "=";
              ahead = "↑$count";
              behind = "↓$count";
              diverged = "↑$ahead_count↓$behind_count";
              up_to_date = "✓";
              untracked = "?$count";
              stashed = "󰏖 ";
              modified = "!$count";
              staged = "+$count";
              renamed = "»$count";
              deleted = "⨯$count";
            };
            git_state = {
              disabled = false;
            };
            git_status = {
              disabled = false;
            };
            git_metrics = {
              disabled = false;
            };
            status = {
              disabled = false;
              format = "[$status ]($style)";
            };
          };
        };
      };
    })
  ];
}
