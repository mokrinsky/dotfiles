{
  config,
  pkgs,
  lib,
  configRoot,
  ...
}: {
  home.activation = lib.mkIf (configRoot.username != "root") {
    # TODO: bat can fetch them with nix function. Maybe I should write PR so fish could do that as well...
    executeCustomScripts = config.lib.dag.entryAfter ["linkGeneration"] ''
      echo ":: Getting fish theme..."
      mkdir -p ${config.home.homeDirectory}/.config/fish/themes
      curl https://raw.githubusercontent.com/catppuccin/fish/main/themes/Catppuccin%20Mocha.theme -o ${config.home.homeDirectory}/.config/fish/themes/mocha.theme &> /dev/null
    '';
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      neofetch = "neofetch --ascii ${config.home.homeDirectory}/.config/neofetch/megurine.ascii --gap -670";
      ls = "exa -alg --color=always --icons --group-directories-first --octal-permissions --no-permissions --git";
      cat = "bat --decorations never --paging never";
      ps = "procs";
      dig = "dog";
    };
    shellInit = ''
      starship init fish | source
      echo y | fish_config theme save mocha

      set -Ux fish_user_paths
      fish_add_path ${config.home.homeDirectory}/bin
      fish_add_path ${config.home.homeDirectory}/go/bin
      fish_add_path ${config.home.profileDirectory}/bin
      fish_add_path /usr/local/opt/python@3.11/libexec/bin

      set -Ua fish_features ampersand-nobg-in-token qmark-noglob
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
}
