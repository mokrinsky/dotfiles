{inputs, ...}: {
  imports = [
    ../common
    "${inputs.self}/modules/nixos/server.nix"
    "${inputs.self}/modules/nixos/k3s-sops.nix"
    "${inputs.self}/modules/nixos/k3s-agent.nix"
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
    hostName = "k4";
    domain = "lab.kolya.it";
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.2.14";
        prefixLength = 24;
      }
    ];
    defaultGateway.address = "192.168.2.1";
    nameservers = ["192.168.2.254"];
  };
}
