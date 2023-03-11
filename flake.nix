{
  description = "Yumi's nix flake";

  nixConfig.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nixConfig.trusted-substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yumi = {
      url = "github:mokrinsky/nix-packages";
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

  outputs = {
    self,
    nur,
    yumi,
    nixpkgs,
    darwin,
    home-manager,
    flake-utils,
    pre-commit-hooks,
  }: let
    nur-overlays = final: prev: {
      nur = import nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = {yumi = import yumi {pkgs = prev;};};
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
            nixPath = ["nixpkgs=${nixpkgs}"];
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
          inherit pkgs system;

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
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [nur-overlays];
          };
        in {
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                alejandra.enable = true;
                editorconfig-checker.enable = true;
                deadnix.enable = true;
                statix.enable = true;
                stylua.enable = true;
                pylint.enable = true;
              };
              settings.pylint.binPath = "pylint";
              settings.deadnix = {
                noLambdaPatternNames = true;
                noLambdaArg = true;
              };
            };
          };
          devShells.default = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            packages = [
              pkgs.just
            ];
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
