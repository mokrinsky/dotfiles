{pkgs, ...}: {
  home = {
    sessionVariables = {
      VISUAL = "$EDITOR";
      SUDO_EDITOR = "$EDITOR";
    };
  };

  xdg.configFile."nvim" = {
    source = ./neovim;
  };

  xdg.configFile."lazyvim" = {
    source = ./lazyvim;
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
      # Linters
      alejandra
      deadnix
      statix
      selene
      stylua
      yamlfmt
      codespell
      shellcheck
      commitlint
      # Language servers
      yaml-language-server
      gopls
      ansible-language-server
      sumneko-lua-language-server
      rnix-lsp
      nil
      pyright

      nodePackages.dockerfile-language-server-nodejs
      nodePackages.typescript-language-server
      nodePackages.prettier
    ];
  };
}
