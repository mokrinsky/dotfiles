{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.yumi.neovim;
in {
  options.yumi.neovim = {
    enable = mkEnableOption "Enable neovim config";
    withLazyVim = mkEnableOption "Install LazyVim config";
    withSessionVariables = mkEnableOption "Enable VISUAL, MANPAGER and SUDO_EDITOR session variables";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home = {
        sessionVariables =
          {
            FZF_DEFAULT_OPTS = "--cycle --border --height=90% --preview-window=wrap --marker=\"*\"";
          }
          // mkIf cfg.withSessionVariables {
            VISUAL = "$EDITOR";
            SUDO_EDITOR = "$EDITOR";
            MANPAGER = "nvim +Man!";
            EDITOR = "nvim";
          };
        packages = with pkgs; [
          (callPackage ../../packages/neovim {})
        ];
      };

      xdg.configFile."nvim" = {
        source = ./neovim;
      };

      programs.fish.shellAliases = {
        vimdiff = "nvim -d";
        vi = "nvim";
        vim = "nvim";
      };
    }

    (mkIf cfg.withLazyVim {
      xdg.configFile."lazyvim" = {
        source = ./lazyvim;
      };

      programs.fish.shellAliases.lazyvim = "NVIM_APPNAME=lazyvim nvim";
    })
  ]);
}
