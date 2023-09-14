{inputs, ...}: {
  imports = [
    ../common
    "${inputs.self}/modules/nixos/server.nix"
    "${inputs.self}/modules/nixos/k3s-sops.nix"
    "${inputs.self}/modules/nixos/k3s-server.nix"
  ];

  boot = {
    initrd.availableKernelModules = ["ata_piix" "mptspi" "ehci_pci" "uhci_hcd" "sd_mod" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = ["nfs" "nfs4"];
  };

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
    hostName = "";
    interfaces.eth0.useDHCP = true;
  };
}
