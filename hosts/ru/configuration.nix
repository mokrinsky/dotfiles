{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  ru = pkgs.substituteAll {
    src = "${inputs.self}/shared/ip-ranges/ru.txt";
    prefix = "  network ";
  };
in {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = "1";
    "net.ipv6.conf.default.forwarding" = "1";
    "net.ipv4.ip_forward" = "1";
  };

  time.timeZone = "Europe/Moscow";

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
    openconnect
    cloak
  ];

  sops = {
    defaultSopsFile = ../../secrets/ru.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      "openvpn/ca.crt".path = "/etc/openvpn/ca.crt";
      "openvpn/server.crt".path = "/etc/openvpn/server.crt";
      "openvpn/server.key".path = "/etc/openvpn/server.key";
      "openvpn/dh2048.pem".path = "/etc/openvpn/dh2048.pem";
      "openvpn/config" = {};
      "wg/privateKey" = {};
    };
  };

  system.stateVersion = "23.05";
  networking = {
    hostName = "ru";
    domain = "kolya.it";
    networkmanager.enable = false;
    wireless.enable = false;
    nat = {
      enable = true;
      internalIPs = ["192.168.253.0/24" "192.168.255.0/24"];
    };
    firewall = {
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [
        19333
        80
        443
        179
      ];
      allowedUDPPorts = [
        1194
        8213
      ];
      enable = true;
    };
    wireguard = {
      interfaces = {
        wg0 = {
          ips = ["192.168.253.1/24"];
          listenPort = 8213;
          privateKeyFile = config.sops.secrets."wg/privateKey".path;
          peers = [
            {
              name = "bogoden";
              publicKey = "eJgoBWQt9gRlLhO5rzUWwufExiuR6SNzrtdPkW6zz0M=";
              allowedIPs = ["192.168.253.2/32"];
            }
            {
              name = "green";
              publicKey = "8Dmm5nyCIGMjJ2zv1SkYAjr+kWHqjQXy1evYQXFe9jk=";
              allowedIPs = ["192.168.253.3/32"];
            }
            {
              name = "mbp";
              publicKey = "hiiI52MWUxUOb9sWRugc/rMGCxrH+dBwN+WObqt4CEY=";
              allowedIPs = ["192.168.253.4/32"];
            }
            {
              name = "ipad";
              publicKey = "jJm9LizeFCq/qCj67TPw1t16sNilnRIhY00yOzn5+kc=";
              allowedIPs = ["192.168.253.5/32"];
            }
            {
              name = "apermade";
              publicKey = "3AoqIcEJus/botarevEFMIehoeDIYw0Qs0A3WnDyA04=";
              allowedIPs = ["192.168.253.6/32"];
            }
            {
              name = "owl";
              publicKey = "VtZ8L8g2yKZUjhRPQecF0f24WneBF+uxS2BlwhhFZhQ=";
              allowedIPs = ["192.168.253.7/32"];
            }
            {
              name = "lavriv";
              publicKey = "k7HnP/LN57ZTaVRreN0LYJMIjrkUkpppVJUx1pWXQQc=";
              allowedIPs = ["192.168.253.8/32"];
            }
            {
              name = "vsalnikova";
              publicKey = "ugnH3K1xs8bu42mNgTjz7yua8X8IpcJ2XRRdqTlQKlA=";
              allowedIPs = ["192.168.253.9/32"];
            }
            {
              name = "kulychevaa";
              publicKey = "KiezRV3t23p8QRY3hJbEBMRm8qNQLWP0bFIu8lx4Vx0=";
              allowedIPs = ["192.168.253.10/32"];
            }
            {
              name = "aaronchikov";
              publicKey = "jcojWbtqBnjQDnKMXXlQc+kX3kHgfTAn0V/Oi7bEm2c=";
              allowedIPs = ["192.168.253.11/32"];
            }
            {
              name = "sabomov";
              publicKey = "C6GHdtWN3BxIF0DVx7/XGB7maUbhZnifDEBjyhLSVEs=";
              allowedIPs = ["192.168.253.12/32"];
            }
            {
              name = "sabomov_v2";
              publicKey = "f1lNooi1anFZt00BW3Saz6r3+UzBV2tzwGnZz06oBk8=";
              allowedIPs = ["192.168.253.13/32"];
            }
            {
              name = "kulychevaa_mbp";
              publicKey = "nKKvqyf3oPG40B313jzzBJGqi1TpwSLjcm7HED2bg2w=";
              allowedIPs = ["192.168.253.14/32"];
            }
          ];
        };
      };
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
    # nginx = {
    #   enable = true;
    #   enableReload = true;
    #   recommendedBrotliSettings = true;
    #   recommendedGzipSettings = true;
    #   additionalModules = with pkgs; [
    #     nginxModules.fancyindex
    #   ];
    #   virtualHosts = {
    #     "share.kolya.it" = {
    #       forceSSL = true;
    #       sslCertificate = "/root/.acme.sh/kolya.it/fullchain.cer";
    #       sslCertificateKey = "/root/.acme.sh/kolya.it/kolya.it.key";
    #       sslTrustedCertificate = "/root/.acme.sh/kolya.it/fullchain.cer";
    #       locations."/" = {
    #         proxyPass = "http://localhost:3000";
    #       };
    #     };
    #   };
    # };
    frr = {
      bgp = {
        enable = true;
        # editorconfig-checker-disable
        config = ''
          router bgp 65500
           bgp router-id 88.218.62.7
           bgp log-neighbor-changes
           no bgp hard-administrative-reset
           no bgp graceful-restart notification
           bgp route-reflector allow-outbound-policy
           no bgp network import-check
           neighbor PRIVATE peer-group
           neighbor PRIVATE remote-as internal
           neighbor 192.168.255.4 peer-group PRIVATE
           neighbor 192.168.255.8 peer-group PRIVATE
           neighbor 192.168.255.9 peer-group PRIVATE
           !
           address-family ipv4 unicast
          ${builtins.readFile ru}
            neighbor PRIVATE route-reflector-client
            neighbor 192.168.255.4 route-map HOME out
            neighbor 192.168.255.8 route-map OWL out
          !
          route-map HOME deny 1
           match ip next-hop address 192.168.255.4
          exit
          !
          route-map HOME permit 2
          exit
          !
          route-map OWL deny 1
           match ip next-hop address 192.168.255.8
          exit
          !
          route-map OWL permit 2
          exit
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
      "ru" = {
        config = "config ${config.sops.secrets."openvpn/config".path}";
      };
    };
  };
}
