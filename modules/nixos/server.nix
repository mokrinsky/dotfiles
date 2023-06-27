{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  nix.gc = {
    options = lib.mkForce "-d";
    dates = "01:00";
  };

  networking = {
    networkmanager.enable = false;
    wireless.enable = false;
    firewall.enable = false;
    usePredictableInterfaceNames = false;
  };

  virtualisation.vmware.guest.enable = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
  };

  fonts.fontconfig.enable = lib.mkDefault false;

  sound.enable = false;
  hardware.pulseaudio.enable = false;

  systemd = {
    enableEmergencyMode = false;

    watchdog = {
      runtimeTime = "20s";
      rebootTime = "30s";
    };

    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };

  environment.systemPackages = with pkgs; [
    curl
    screen
    mc
    nix-tree
    tcpdump
    python3
  ];

  system.stateVersion = "23.05";
  system.autoUpgrade = {
    enable = true;
    flake = "github:mokrinsky/dotfiles";
  };
  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      withRuby = false;
    };
    git.enable = true;
  };
  services = {
    openssh = {
      enable = true;
      ports = [19333];
      settings = {
        KbdInteractiveAuthentication = false;
        UseDns = false;
        X11Forwarding = false;
        PermitRootLogin = "yes";
      };
    };
  };
}
