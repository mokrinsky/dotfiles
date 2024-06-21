{inputs, ...}: let
  myLib = import ../lib {inherit inputs;};
in {
  flake = with inputs; {
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
      ru = myLib.mkConfiguration {
        builder = nixpkgs.lib.nixosSystem;
        modules = [
          self.nixosModules.extra
          sops.nixosModules.sops
          ({pkgs, ...}: {
            nixpkgs.overlays = [self.overlays.default];
          })
        ];
        name = "ru";
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
      };
    };

    darwinConfigurations = {
      hitagi = myLib.mkConfiguration {
        builder = darwin.lib.darwinSystem;
        modules = [
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
      rc = myLib.mkConfiguration {
        builder = darwin.lib.darwinSystem;
        modules = [
          ../users/nikolay.mokrinsky
          home-manager.darwinModules.home-manager
          self.darwinModules.extra
          ({pkgs, ...}: {
            nixpkgs.overlays = [self.overlays.default];
          })
        ];
        name = "rc";
        specialArgs = {
          inherit inputs;
        };
        system = "aarch64-darwin";
      };
    };
  };
}
