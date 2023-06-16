{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot.initrd.availableKernelModules = ["ata_piix" "mptspi" "ehci_pci" "uhci_hcd" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];

  networking = {
    interfaces.ens33.ipv4.addresses = [
      {
        address = "192.168.2.13";
        prefixLength = 24;
      }
    ];
    defaultGateway.address = "192.168.2.1";
    nameservers = ["192.168.2.254"];
  };

  virtualisation.vmware.guest.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
