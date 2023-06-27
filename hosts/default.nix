{inputs, ...}: let
  myLib = import ../lib {inherit inputs;};
in {
  flake = with inputs; let
    buildKubeHost = name:
      myLib.mkConfiguration {
        inherit name;
        builder = nixpkgs.lib.nixosSystem;
        modules = [
          self.nixosModules.extra
          sops.nixosModules.sops
          ({pkgs, ...}: {
            nixpkgs.overlays = [self.overlays.default];
          })
        ];
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
      };
  in {
    nixosConfigurations = {
      argolab = myLib.mkConfiguration {
        builder = nixpkgs.lib.nixosSystem;
        modules = [
          self.nixosModules.extra
          ({pkgs, ...}: {
            nixpkgs.overlays = [self.overlays.default];
          })
        ];
        name = "argolab";
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
      };
      k1 = buildKubeHost "k1";
      k2 = buildKubeHost "k2";
      k3 = buildKubeHost "k3";
      k4 = buildKubeHost "k4";
      k5 = buildKubeHost "k5";
      k6 = buildKubeHost "k6";
      k7 = buildKubeHost "k7";
      nl = myLib.mkConfiguration {
        builder = nixpkgs.lib.nixosSystem;
        modules = [
          self.nixosModules.extra
          sops.nixosModules.sops
          ({pkgs, ...}: {
            nixpkgs.overlays = [self.overlays.default];
          })
        ];
        name = "nl";
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
      };
    };

    darwinConfigurations = {
      millia = myLib.mkConfiguration {
        builder = darwin.lib.darwinSystem;
        modules = [
          ../config
          ../users/yumi
          home-manager.darwinModules.home-manager
          self.darwinModules.extra
          ({pkgs, ...}: {
            nixpkgs.overlays = [self.overlays.default];
          })
        ];
        name = "millia";
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-darwin";
      };

      hitagi = myLib.mkConfiguration {
        builder = darwin.lib.darwinSystem;
        modules = [
          ../config
          ../users/yumi
          home-manager.darwinModules.home-manager
          self.darwinModules.extra
          ({pkgs, ...}: {
            nixpkgs.overlays = [self.overlays.default];
          })
        ];
        name = "hitagi";
        specialArgs = {
          inherit inputs;
        };
        system = "aarch64-darwin";
      };
    };
  };
}
