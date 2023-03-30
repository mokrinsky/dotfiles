{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."nvim" = {
    source = ./configs/nvim_config;
  };

  xdg.configFile."lazyvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "LazyVim";
      repo = "starter";
      rev = "9ad6acdff121ad344cebeb640b48e6ed4d5a8f58";
      sha256 = "sha256-F/jipxu8+I0uIJBdTc8PdTFXDwTX7dYYudGessV9xh4=";
    };
  };

  programs.neovim = {
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
