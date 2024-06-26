{
  description = "Yumi's nix flake";

  inputs = {
    # core inputs
    nixpkgs.url = "nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR inputs
    nur.url = "github:nix-community/NUR";
    yumi = {
      url = "github:mokrinsky/nix-packages";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
    };

    # QoL inputs
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs-stable.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:mokrinsky/nix-ctp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-nix = {
      url = "github:catppuccin/nix";
    };
    sops = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs-stable.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };

    # Development inputs
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    # yumi-dev = {
    #   url = "path:/Users/yumi/git/nix-overlay";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    # };
    # nixpkgs-dev = {
    #   url = "path:/Users/yumi/git/nixpkgs";
    # };

    # Dependencies
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = inputs @ {
    self,
    darwin,
    devshell,
    flake-parts,
    home-manager,
    nixpkgs,
    # nixpkgs-dev,
    nixpkgs-unstable,
    nur,
    pre-commit-hooks,
    sops,
    yumi,
    catppuccin-nix,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        pre-commit-hooks.flakeModule
        devshell.flakeModule
        ./hosts
      ];

      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

      perSystem = {
        config,
        pkgs,
        system,
        lib,
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };
        pre-commit = {
          check.enable = true;
          settings = {
            src = ./.;
            hooks = {
              typos = {
                enable = true;
                excludes = ["secrets/.*" ".sops.yaml"];
              };
              alejandra.enable = true;
              editorconfig-checker.enable = false;
              statix.enable = true;
              nil.enable = true;
              deadnix.settings = {
                noLambdaPatternNames = true;
                noLambdaArg = true;
              };
              typos.settings = {
                exclude = ".sops.yaml --exclude secrets/*";
              };
            };
          };
        };

        devshells.default = {
          devshell = {
            startup.test.text = ''
              ${config.pre-commit.installationScript}
            '';
            name = "devShell";
          };
          packages = [
            pkgs.pre-commit
          ];
          commands = [
            {
              help = "code style check";
              name = "check";
              command = "${lib.getExe pkgs.pre-commit} run --all-files";
            }
            {
              help = "show flake outputs";
              name = "show";
              command = "nix flake show";
            }
            {
              help = "show flake metadata";
              name = "meta";
              command = "nix flake metadata";
            }
          ];
        };

        formatter = pkgs.alejandra;
      };

      flake = {
        nixosModules.extra = import ./modules/system;
        darwinModules.extra = import ./modules/system;
        homeManagerModules.bundle = import ./modules/hm;

        overlays.default = _final: prev: {
          unstable = import nixpkgs-unstable {
            inherit (prev) system;
            config.allowUnfree = true;
          };
          nur = import nur {
            nurpkgs = prev;
            pkgs = prev;
            repoOverrides = {
              yumi = import yumi {pkgs = prev;};
            };
          };
          # dev = import nixpkgs-dev {
          #   inherit (prev) system;
          #   config.allowUnfree = true;
          # };
          inherit (yumi.packages.${prev.system}) wireguard-tools;
        };

        homeConfigurations.placeholder = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            overlays = [self.overlays.default];
          };
          modules = [
            yumi.homeManagerModules.default
            sops.homeManagerModules.sops
            self.homeManagerModules.bundle
            catppuccin-nix.homeManagerModules.catppuccin
            ./users/yumi/include.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      };
    };
}
