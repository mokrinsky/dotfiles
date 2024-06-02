{
  pkgs,
  lib,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
  };

  documentation = {
    enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
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
  ];

  system.stateVersion = "23.05";
  networking = {
    hostName = "argo";
    domain = "lab.kolya.it";
    networkmanager.enable = false;
    wireless.enable = false;
    firewall.enable = false;
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
    k3s = {
      enable = true;
      extraFlags = "--disable traefik --disable metrics-server --flannel-backend=none --disable-network-policy";
    };
    openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        UseDns = false;
        X11Forwarding = false;
      };
    };
    coredns = {
      enable = true;
      config = ''
        .:53 {
            errors
            health
            ready
            hosts {
              192.168.2.254 argocd.lab.kolya.it
              192.168.2.252 vm.lab.kolya.it
              ttl 60
              reload 15s
              fallthrough
            }
            prometheus :9153
            forward . 8.8.8.8 8.8.4.4
            cache 30
            loop
            reload
            loadbalance
        }
      '';
    };
  };
}
