{...}: {
  imports = [
    ./secure.nix
    ./gnu.nix
  ];
  yumi = {
    brew.enable = true;
    darwin.enable = true;
    fish = {
      enable = true;
      withStarship = true;
      withGrc = true;
      withCatppuccin = true;
    };
    fonts.enable = true;
    git.enable = true;
    k8s.enable = true;
    neovim = {
      enable = true;
      withLazyVim = true;
      withSessionVariables = true;
    };
    python = {
      enable = true;
      withAnsible = true;
    };
    sketchybar.enable = true;
    wezterm.enable = true;
    yabai = {
      enable = true;
      withSkhd = true;
    };
  };
}
