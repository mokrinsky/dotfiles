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
    gc = {
      automatic = true;
      user = "root";
      options = "--delete-older-than 7d";
    };
    settings = {
      extra-trusted-users = ["yumi"];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nekowinston.cachix.org-1:lucpmaO+JwtoZj16HCO1p1fOv68s/RL1gumpVzRHRDs="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        "mokrinsky.cachix.org-1:PkpcFI8pgsaQpOyoYyMdiA6sXJol1lhfsv6mCiH9jTY="
      ];
      substituters = [
        "https://mokrinsky.cachix.org"
        "https://nix-community.cachix.org"
        "https://pre-commit-hooks.cachix.org"
        "https://nekowinston.cachix.org"
      ];
    };
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
