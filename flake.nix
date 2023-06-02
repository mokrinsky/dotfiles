{
  description = "Yumi's nix flake";

  inputs = {
    # core inputs
    nixpkgs.url = "nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR inputs
    nur.url = "github:nix-community/NUR";
    yumi = {
      url = "github:mokrinsky/nix-packages";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };

    # QoL inputs
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs-stable.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
    catppuccin = {
      url = "github:mokrinsky/nix-ctp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Development inputs
    # yumi-dev = {
    #   url = "path:/Users/yumi/git/nix-overlay";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    # };
    # nixpkgs-dev = {
    #   url = "path:/Users/yumi/git/nixpkgs";
    # };
  };

  outputs = inputs @ {
    self,
    darwin,
    flake-utils,
    home-manager,
    nixpkgs,
    # nixpkgs-dev,
    nixpkgs-unstable,
    nur,
    pre-commit-hooks,
    yumi,
    sops,
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
        };
      };
      # dev = import nixpkgs-dev {
      #   inherit (prev) system;
      #   config.allowUnfree = true;
      # };
      inherit (yumi.packages.${prev.system}) wireguard-tools fzf;
    };
  in
    with nixpkgs.lib; let
      getPkgs = system:
        import nixpkgs {
          inherit system;
          overlays = [overlays];
        };

      userModules = [
        (import ./config)
        (import ./shared)
        (import ./lib/options.nix)
      ];

      hmModule = isNixOS:
        if isNixOS
        then [home-manager.nixosModules.home-manager]
        else [home-manager.darwinModules.home-manager];

      sopsModule = isNixOS:
        if isNixOS
        then [sops.nixosModules.sops]
        else [];

      getSystem = {
        hostname,
        system,
        config,
      }: let
        # TODO: it was worse before, but i still don't like this line
        isNixOS = builtins.match ".*(darwin).*" system == null;
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
          inherit pkgs;
          modules =
            userModules
            ++ hmModule isNixOS
            ++ sopsModule isNixOS
            ++ [
              config
            ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    in
      flake-utils.lib.eachDefaultSystem (system: {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
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
          with pkgs;
            mkShell {
              inherit (self.checks.${system}.pre-commit-check) shellHook;
              name = "devShell";
              packages = [
                commitizen
              ];
            };
      })
      // fold (flip pipe [getSystem recursiveUpdate]) {} (import ./hosts {systems = flake-utils.lib.system;});
}
