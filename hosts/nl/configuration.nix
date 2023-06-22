{
  config,
  pkgs,
  lib,
  ...
}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = "1";
    "net.ipv6.conf.default.forwarding" = "1";
    "net.ipv4.ip_forward" = "1";
  };

  time.timeZone = "Europe/Amsterdam";

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

  sops = {
    defaultSopsFile = ../../secrets/nl.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      "openvpn/ca.crt".path = "/etc/openvpn/ca.crt";
      "openvpn/nl.crt".path = "/etc/openvpn/nl.crt";
      "openvpn/nl.key".path = "/etc/openvpn/nl.key";
      "openvpn/config" = {};
    };
  };

  system.stateVersion = "23.05";
  networking = {
    hostName = "nl";
    domain = "kolya.it";
    networkmanager.enable = false;
    wireless.enable = false;
    firewall = {
      trustedInterfaces = ["lxc*"];
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [
        19333
        22
        2222
        443
        6443
        80
      ];
      enable = true;
    };
  };
  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      withRuby = false;
    };
    git.enable = true;
    traceroute.enable = true;
    mtr.enable = true;
  };
  services = {
    frr = {
      bgp = {
        enable = true;
        # editorconfig-checker-disable
        config = ''
          router bgp 65500
           bgp router-id 109.107.176.26
           bgp log-neighbor-changes
           no bgp hard-administrative-reset
           no bgp graceful-restart notification
           no bgp network import-check
           neighbor 192.168.255.1 remote-as 65500
           !
           address-family ipv4 unicast
            neighbor 192.168.255.1 route-map IMPORT out
            neighbor 192.168.255.1 route-map IMPORT in
          !
          route-map IMPORT permit 1
           match ip address prefix-list INPUT
          !
          ip prefix-list INPUT seq 5 permit 192.168.0.0/16 le 32
          ip prefix-list INPUT seq 10 deny any
        '';
        # editorconfig-checker-enable
      };
    };
    k3s = {
      enable = true;
      extraFlags = "--disable traefik --disable metrics-server --flannel-backend=none --disable-network-policy";
    };
    openssh = {
      enable = true;
      ports = [19333];
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        UseDns = false;
        X11Forwarding = false;
      };
    };
    fail2ban.enable = true;
    openvpn.servers = {
      "gw-msk" = {
        config = "config ${config.sops.secrets."openvpn/config".path}";
      };
    };
  };
}
