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
          };
      };

      xdg.configFile."nvim" = {
        source = ./neovim;
      };

      programs.neovim = {
        package = pkgs.unstable.neovim-unwrapped;
        withRuby = false;
        withPython3 = true;
        enable = true;
        vimAlias = true;
        viAlias = true;
        vimdiffAlias = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          tree-sitter
          ripgrep
          fd
          # Linters
          alejandra
          ansible-lint
          statix
          selene
          stylua
          yamlfmt
          yamllint
          codespell
          shellcheck
          commitlint
          # Language servers
          yaml-language-server
          gopls
          ansible-language-server
          sumneko-lua-language-server
          nil
          pyright

          nodePackages.dockerfile-language-server-nodejs
          nodePackages.typescript-language-server
          nodePackages.prettier
        ];
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
