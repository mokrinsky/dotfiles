{
  description = "Yumi's nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable"; # this will move to stable upon 23.05 release
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    nur.url = "github:nix-community/NUR";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-utils.follows = "fup";
        nixpkgs.follows = "nixpkgs";
      };
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
        utils.follows = "fup";
      };
    };

    catppuccin = {
      url = "github:mokrinsky/nix-ctp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fu.url = "github:numtide/flake-utils";

    fup = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "fu";
    };
  };

  outputs = inputs @ {
    self,
    nur,
    yumi,
    nekowinston,
    nixpkgs,
    nixpkgs-unstable,
    darwin,
    home-manager,
    pre-commit-hooks,
    fup,
    ...
  }: let
    overlays = _final: prev: {
      unstable = import nixpkgs-unstable {
        inherit (prev) system;
        config.allowUnfree = true;
      };
      nur = import nur {
        nurpkgs = prev;
        pkgs = prev;
        repoOverrides = {
          yumi = import yumi {pkgs = prev;};
          nekowinston = import nekowinston {pkgs = prev;};
        };
      };
    };
  in
    with nixpkgs.lib; let
      userModules = [
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
        cfgs =
          if isNixOS
          then "nixosConfigurations"
          else "darwinConfigurations";
        sys =
          if isNixOS
          then nixpkgs.lib.nixosSystem
          else darwin.lib.darwinSystem;
      in {
        ${hostname} = {
          inherit system;
          builder = sys;
          output = cfgs;
          modules =
            userModules
            ++ hmModule isNixOS
            ++ [
              config
            ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    in
      (fup.lib.eachDefaultSystem (
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
        }
      ))
      // (fup.lib.mkFlake {
        inherit self inputs;

        hosts = fold (flip pipe [getSystem recursiveUpdate]) {} (import ./hosts {systems = fup.lib.system;});

        sharedOverlays = [overlays];

        channels.nixpkgs = {
          input = nixpkgs;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "libressl-3.4.3"
            ];
          };
        };

        outputsBuilder = channels: {
          devShells.default = channels.nixpkgs.mkShell {
            name = "devShell";
            packages = with channels.nixpkgs; [
              commitizen
              just
            ];
          };
        };
      });
}
