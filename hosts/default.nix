{inputs, ...}: let
  myLib = import ../lib {inherit inputs;};
in {
  flake = with inputs; {
    nixosConfigurations.nl = myLib.mkConfiguration {
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
