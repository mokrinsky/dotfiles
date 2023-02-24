{
  config,
  pkgs,
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
      configRoot = config;
    };
    users.${config.username} = {
      home.stateVersion = "22.05";
      imports = [
        ./cmdline.nix
        ./configs.nix
        ./apps
      ];
    };
  };
}
