{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # verbose = true;
    extraSpecialArgs = {
      inherit inputs pkgs;
      configRoot = config;
    };
    users.${config.username} = {
      home.stateVersion = "22.05";
      imports = [
        ./cmdline.nix
        ./configs.nix
        ./fonts.nix
        ./apps
      ];
    };
  };
}
