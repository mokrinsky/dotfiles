{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."nvim" = {
    source = ./configs/nvim_config;
  };

  xdg.configFile."lazyvim" = {
    source = ./configs/lazyvim_config;
  };

  programs.neovim = {
    package = pkgs.nur.repos.yumi.neovim-unwrapped;
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
