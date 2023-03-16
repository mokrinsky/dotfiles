{
  description = "Yumi's nix flake";

  nixConfig.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "nekowinston.cachix.org-1:lucpmaO+JwtoZj16HCO1p1fOv68s/RL1gumpVzRHRDs="
    "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
  ];
  nixConfig.trusted-substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
    "https://pre-commit-hooks.cachix.org"
    "https://nekowinston.cachix.org"
  ];

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    mkAlias = {
      url = "github:reckenrode/mkAlias";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yumi = {
      url = "github:mokrinsky/nix-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nekowinston = {
      url = "github:nekowinston/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nur,
    yumi,
    nekowinston,
    nixpkgs,
    darwin,
    home-manager,
    flake-utils,
    pre-commit-hooks,
    mkAlias,
  }: let
    nur-overlays = final: prev: {
      nur = import nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = {
          yumi = import yumi {pkgs = prev;};
          nekowinston = import nekowinston {pkgs = prev;};
        };
      };
    };
    getLib = {lib, ...}: lib // import ./libs {inherit lib;};
  in
    with getLib nixpkgs; let
      getPkgs = system:
        import nixpkgs {
          inherit system;
          overlays = [nur-overlays];
        };

      userModules = [
        {
          nix = {
            registry.nixpgks.flake = nixpkgs;
          };
        }
        (import ./config)
        (import ./shared)
      ];

      hmModule = isNixOS:
        if isNixOS
        then [home-manager.nixosModules.home-manager]
        else [home-manager.darwinModules.home-manager];

      getSystem = {
        hostname,
        system,
        isNixOS,
        config,
      }: let
        pkgs = getPkgs system;
        cfgs =
          if isNixOS
          then "nixosConfigurations"
          else "darwinConfigurations";
        sys =
          if isNixOS
          then nixpkgs.lib.nixosSystem
          else darwin.lib.darwinSystem;
      in {
        ${cfgs}.${hostname} = sys {
          inherit pkgs inputs;

          modules =
            userModules
            ++ hmModule isNixOS
            ++ [
              config
            ];

          specialArgs = {lib = getLib pkgs;};
        };
      };
    in
      (flake-utils.lib.eachDefaultSystem (
        system: {
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                alejandra.enable = true;
                editorconfig-checker.enable = true;
                deadnix.enable = true;
                statix.enable = true;
              };
              settings.deadnix = {
                noLambdaPatternNames = true;
                noLambdaArg = true;
              };
            };
          };
          devShells.default = let
            pkgs = nixpkgs.legacyPackages.${system};
          in
            pkgs.mkShell {
              inherit (self.checks.${system}.pre-commit-check) shellHook;
            };
        }
      ))
      // (
        let
          f = fold (compose [getSystem recursiveUpdate]) {};
        in
          f (import ./hosts {systems = flake-utils.lib.system;})
      );
}
