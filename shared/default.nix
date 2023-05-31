{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix = {
    linkInputs = true;
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      warn-dirty = false;
      extra-trusted-users = ["yumi"];
      tarball-ttl = 604800;
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        "mokrinsky.cachix.org-1:PkpcFI8pgsaQpOyoYyMdiA6sXJol1lhfsv6mCiH9jTY="
      ];
      substituters = [
        "https://mokrinsky.cachix.org"
        "https://nix-community.cachix.org"
        "https://pre-commit-hooks.cachix.org"
      ];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.yumi.homeManagerModules.default
      inputs.sops.homeManagerModules.sops
      ../modules/hm
      (import ../config)
    ];
    # verbose = true;
    extraSpecialArgs = {
      inherit inputs pkgs;
    };
    users.${config.username} = {
      home.stateVersion = "22.05";
      imports = [
        ./base.nix
        ./configs.nix
        ./apps
      ];
    };
  };
}
