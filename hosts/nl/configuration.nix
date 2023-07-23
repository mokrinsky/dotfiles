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

  users.users.root.openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDN/RoHDGD9Lesp2Jtsh2PHySC/2p0QyGAqsbKeh5Lj01UN+Sw5BguJEcS0Uzng/fhvxU03VH9xQ9lZXpd9lW5DA3wIV7L1zjLmrif7g4UTe9BRhQw6S9lX3yOd1zgpEUCQjDPhNpdu8y48nOkkFKNCidzBQOegrqbfYcQCAyQWNA+R42nR9JfcWj/Tbb5P3Crt5JIfdSwZZU2JQZrS7CePdK2BFDndH5MvtzQkOhpm7U6cOcdn8VaacEVfCDQrSeO0TiB4SwOKOqhlBUajC0hBcE06447TMQ+Of7a0xo/lY7LhI8banwCqUU2nzTNa8JamyPq7rraUzFsrAwj9sx7akfIxaB91c1lr3P+nQlD+t7IePUmqhfwsMIW7h/Z0d72icJwRmEZ+9N2R1MNFVWBhV1nhN9fs8G4NABa0gFJ5Jp5u1VDO0ny0ZS42HJNJ7977AtrdFRRyt3QWDOMYMaXRUACugB0ZoSdl6n0WGSqGJ0/sY4GJO9LXAB64vGTz1kqFgKF1IhGvRSgP+SZEGjYnehSckjbIWzq0yrxqj7nytPOpctyPXL+MNAujBPeKmPeqVk0INdWY4Qzlrs9S/VkPl9vM2IWdgVIb4e6KYsnk46LPLum8mx/tW7k83yUwrLZN19SJ62cQgLM9aIIdRt4rm2QfSXiAzW5wantX28+9rQ== cardno:20_871_074"];

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
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [
        19333
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
            network 120.52.22.96/27
            network 205.251.249.0/24
            network 180.163.57.128/26
            network 204.246.168.0/22
            network 111.13.171.128/26
            network 18.160.0.0/15
            network 205.251.252.0/23
            network 54.192.0.0/16
            network 204.246.173.0/24
            network 54.230.200.0/21
            network 120.253.240.192/26
            network 116.129.226.128/26
            network 130.176.0.0/17
            network 108.156.0.0/14
            network 99.86.0.0/16
            network 205.251.200.0/21
            network 13.32.0.0/15
            network 120.253.245.128/26
            network 13.224.0.0/14
            network 70.132.0.0/18
            network 15.158.0.0/16
            network 111.13.171.192/26
            network 13.249.0.0/16
            network 18.238.0.0/15
            network 18.244.0.0/15
            network 205.251.208.0/20
            network 65.9.128.0/18
            network 130.176.128.0/18
            network 58.254.138.0/25
            network 54.230.208.0/20
            network 3.160.0.0/14
            network 116.129.226.0/25
            network 52.222.128.0/17
            network 18.164.0.0/15
            network 111.13.185.32/27
            network 64.252.128.0/18
            network 205.251.254.0/24
            network 54.230.224.0/19
            network 71.152.0.0/17
            network 216.137.32.0/19
            network 204.246.172.0/24
            network 18.172.0.0/15
            network 120.52.39.128/27
            network 118.193.97.64/26
            network 18.154.0.0/15
            network 54.240.128.0/18
            network 205.251.250.0/23
            network 180.163.57.0/25
            network 52.46.0.0/18
            network 52.82.128.0/19
            network 54.230.0.0/17
            network 54.230.128.0/18
            network 54.239.128.0/18
            network 130.176.224.0/20
            network 36.103.232.128/26
            network 52.84.0.0/15
            network 143.204.0.0/16
            network 144.220.0.0/16
            network 120.52.153.192/26
            network 119.147.182.0/25
            network 120.232.236.0/25
            network 111.13.185.64/27
            network 3.164.0.0/18
            network 54.182.0.0/16
            network 58.254.138.128/26
            network 120.253.245.192/27
            network 54.239.192.0/19
            network 18.68.0.0/16
            network 18.64.0.0/14
            network 120.52.12.64/26
            network 99.84.0.0/16
            network 130.176.192.0/19
            network 52.124.128.0/17
            network 204.246.164.0/22
            network 13.35.0.0/16
            network 204.246.174.0/23
            network 3.172.0.0/18
            network 36.103.232.0/25
            network 119.147.182.128/26
            network 118.193.97.128/25
            network 120.232.236.128/26
            network 204.246.176.0/20
            network 65.8.0.0/16
            network 65.9.0.0/17
            network 108.138.0.0/15
            network 120.253.241.160/27
            network 64.252.64.0/18
            network 13.113.196.64/26
            network 13.113.203.0/24
            network 52.199.127.192/26
            network 13.124.199.0/24
            network 3.35.130.128/25
            network 52.78.247.128/26
            network 13.233.177.192/26
            network 15.207.13.128/25
            network 15.207.213.128/25
            network 52.66.194.128/26
            network 13.228.69.0/24
            network 52.220.191.0/26
            network 13.210.67.128/26
            network 13.54.63.128/26
            network 43.218.56.128/26
            network 43.218.56.192/26
            network 43.218.56.64/26
            network 43.218.71.0/26
            network 99.79.169.0/24
            network 18.192.142.0/23
            network 35.158.136.0/24
            network 52.57.254.0/24
            network 13.48.32.0/24
            network 18.200.212.0/23
            network 52.212.248.0/26
            network 3.10.17.128/25
            network 3.11.53.0/24
            network 52.56.127.0/25
            network 15.188.184.0/24
            network 52.47.139.0/24
            network 3.29.40.128/26
            network 3.29.40.192/26
            network 3.29.40.64/26
            network 3.29.57.0/26
            network 18.229.220.192/26
            network 54.233.255.128/26
            network 3.231.2.0/25
            network 3.234.232.224/27
            network 3.236.169.192/26
            network 3.236.48.0/23
            network 34.195.252.0/24
            network 34.226.14.0/24
            network 13.59.250.0/26
            network 18.216.170.128/25
            network 3.128.93.0/24
            network 3.134.215.0/24
            network 52.15.127.128/26
            network 3.101.158.0/23
            network 52.52.191.128/26
            network 34.216.51.0/25
            network 34.223.12.224/27
            network 34.223.80.192/26
            network 35.162.63.192/26
            network 35.167.191.128/26
            network 44.227.178.0/24
            network 44.234.108.128/25
            network 44.234.90.252/30
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
