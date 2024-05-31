{
  pkgs,
  inputs,
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.yumi.homeManagerModules.default
      inputs.sops.homeManagerModules.sops
      inputs.self.homeManagerModules.bundle
      inputs.catppuccin-nix.homeManagerModules.catppuccin
    ];
    # verbose = true;
    extraSpecialArgs = {
      inherit inputs pkgs;
    };
    users.yumi = {
      home.stateVersion = "23.05";
      imports = [
        ./include.nix
      ];
    };
  };
}
