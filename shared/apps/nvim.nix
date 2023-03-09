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
      # I prefer using Mason, but some packages are not present in here
      alejandra
      tree-sitter
    ];
  };
}
