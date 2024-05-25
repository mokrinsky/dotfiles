{pkgs, ...}: {
  nixpkgs.config = {
    allowUnfree = true;
  };
  nix = {
    package = pkgs.unstable.nixVersions.nix_2_18;

    linkInputs = true;
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      warn-dirty = false;
      extra-trusted-users = ["yumi" "@admin" "@wheel"];
      tarball-ttl = 604800;
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        "mokrinsky.cachix.org-1:PkpcFI8pgsaQpOyoYyMdiA6sXJol1lhfsv6mCiH9jTY="
      ];
      substituters = [
        "https://mokrinsky.cachix.org"
        "https://nix-community.cachix.org"
        "https://pre-commit-hooks.cachix.org"
      ];
    };
  };
}
