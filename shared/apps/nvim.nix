{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."nvim" = {
    source = ./configs/nvim_config;
  };

  programs.neovim = {
    withRuby = false;
    withPython3 = false;
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
      yamllint
      ansible-lint
      yamlfmt
      codespell
      black
      pylint
      # Language servers
      yaml-language-server
      gopls
      ansible-language-server
      sumneko-lua-language-server
      rnix-lsp
      pyright
      nodePackages.dockerfile-language-server-nodejs
    ];
  };
}
