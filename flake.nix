{
  description = "Yumi's nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-utils.follows = "flake-utils-plus";
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils-plus";
      };
    };

    catppuccin = {
      url = "github:mokrinsky/nix-ctp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
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
    flake-utils-plus,
    pre-commit-hooks,
    mkAlias,
    catppuccin,
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
          config.permittedInsecurePackages = [
            "libressl-3.4.3"
          ];
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
      (flake-utils-plus.lib.eachDefaultSystem (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [nur-overlays];
          };
        in {
          channels.nixpkgs = {
            input = nixpkgs;
            config.allowUnfree = true;
          };
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                alejandra.enable = true;
                editorconfig-checker.enable = true;
                deadnix.enable = true;
                statix.enable = true;
                stylua.enable = true;
                shellcheck.enable = true;
              };
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
          f (import ./hosts {systems = flake-utils-plus.lib.system;})
      );
}
