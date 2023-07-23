{lib, ...}: {
  imports = [];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["tap"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
    mountPoint = "/";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext2";
    mountPoint = "/boot";
  };

  swapDevices = [
    {device = "/dev/disk/by-label/swap";}
  ];

  networking = {
    interfaces.ens3.ipv4.addresses = [
      {
        address = "77.246.107.96";
        prefixLength = 24;
      }
    ];
    defaultGateway.address = "77.246.107.1";
    nameservers = ["8.8.8.8" "8.8.4.4"];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.hypervGuest.enable = true;
}
