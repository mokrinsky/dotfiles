{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  as32934 = pkgs.substituteAll {
    src = "${inputs.self}/shared/ip-ranges/as32934-fb.txt";
    prefix = "  network ";
  };
  as54115 = pkgs.substituteAll {
    src = "${inputs.self}/shared/ip-ranges/as54115-fb.txt";
    prefix = "  network ";
  };
  as63293 = pkgs.substituteAll {
    src = "${inputs.self}/shared/ip-ranges/as63293-fb.txt";
    prefix = "  network ";
  };
  as16509 = pkgs.substituteAll {
    src = "${inputs.self}/shared/ip-ranges/as16509-cloudfront.txt";
    prefix = "  network ";
  };
  nonprefix = pkgs.substituteAll {
    src = "${inputs.self}/shared/ip-ranges/nonprefix-fb.txt";
    prefix = "  network ";
  };
  nl = pkgs.substituteAll {
    src = "${inputs.self}/shared/ip-ranges/nl.txt";
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
      "wg/privateKey" = {};
    };
  };

  system.stateVersion = "23.05";
  networking = {
    hostName = "nl";
    domain = "kolya.it";
    networkmanager.enable = false;
    wireless.enable = false;
    nat = {
      enable = true;
      internalIPs = ["192.168.254.0/24" "192.168.255.0/24"];
    };
    firewall = {
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [
        19333
        179
        9000
      ];
      allowedUDPPorts = [
        8213
      ];
      trustedInterfaces = ["tap0"];
      enable = true;
    };
    wireguard = {
      interfaces = {
        wg0 = {
          ips = ["192.168.254.1/24"];
          listenPort = 8213;
          privateKeyFile = config.sops.secrets."wg/privateKey".path;
          peers = [
            {
              name = "bogoden";
              publicKey = "eJgoBWQt9gRlLhO5rzUWwufExiuR6SNzrtdPkW6zz0M=";
              allowedIPs = ["192.168.254.2/32"];
            }
            {
              name = "green";
              publicKey = "8Dmm5nyCIGMjJ2zv1SkYAjr+kWHqjQXy1evYQXFe9jk=";
              allowedIPs = ["192.168.254.3/32"];
            }
            {
              name = "mbp";
              publicKey = "hiiI52MWUxUOb9sWRugc/rMGCxrH+dBwN+WObqt4CEY=";
              allowedIPs = ["192.168.254.4/32"];
            }
            {
              name = "ipad";
              publicKey = "jJm9LizeFCq/qCj67TPw1t16sNilnRIhY00yOzn5+kc=";
              allowedIPs = ["192.168.254.5/32"];
            }
            {
              name = "apermade";
              publicKey = "3AoqIcEJus/botarevEFMIehoeDIYw0Qs0A3WnDyA04=";
              allowedIPs = ["192.168.254.6/32"];
            }
            {
              name = "owl";
              publicKey = "VtZ8L8g2yKZUjhRPQecF0f24WneBF+uxS2BlwhhFZhQ=";
              allowedIPs = ["192.168.254.7/32"];
            }
            {
              name = "lavriv";
              publicKey = "k7HnP/LN57ZTaVRreN0LYJMIjrkUkpppVJUx1pWXQQc=";
              allowedIPs = ["192.168.254.8/32"];
            }
            {
              name = "vsalnikova";
              publicKey = "ugnH3K1xs8bu42mNgTjz7yua8X8IpcJ2XRRdqTlQKlA=";
              allowedIPs = ["192.168.254.9/32"];
            }
            {
              name = "kulychevaa";
              publicKey = "KiezRV3t23p8QRY3hJbEBMRm8qNQLWP0bFIu8lx4Vx0=";
              allowedIPs = ["192.168.254.10/32"];
            }
            {
              name = "aaronchikov";
              publicKey = "jcojWbtqBnjQDnKMXXlQc+kX3kHgfTAn0V/Oi7bEm2c=";
              allowedIPs = ["192.168.254.11/32"];
            }
            {
              name = "sabomov";
              publicKey = "C6GHdtWN3BxIF0DVx7/XGB7maUbhZnifDEBjyhLSVEs=";
              allowedIPs = ["192.168.254.12/32"];
            }
            {
              name = "sabomov_v2";
              publicKey = "f1lNooi1anFZt00BW3Saz6r3+UzBV2tzwGnZz06oBk8=";
              allowedIPs = ["192.168.254.13/32"];
            }
            {
              name = "kulychevaa_mbp";
              publicKey = "nKKvqyf3oPG40B313jzzBJGqi1TpwSLjcm7HED2bg2w=";
              allowedIPs = ["192.168.254.14/32"];
            }
            {
              name = "tomin_a";
              publicKey = "Jr37wO1gDN87h5DDw8HieCnwDpuVVgDiRviSIcBwEww=";
              allowedIPs = ["192.168.254.15/32"];
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
    dante = {
      enable = true;
      config = ''
        internal: tap0
        external: ens3

        clientmethod: none
        method: none

        client pass {
          from: 192.168.0.0/16 to: 0.0.0.0/0
          log: error # connect disconnect
        }

        pass {
          from: 192.168.0.0/16 to: 0.0.0.0/0
          command: bind connect udpassociate
          log: error # connect disconnect iooperation
        }

        pass {
          from: 192.168.0.0/16 to: 0.0.0.0/0
          command: bindreply udpreply
          log: error # connect disconnect iooperation
        }
      '';
    };
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
          ${builtins.readFile as63293}
          ${builtins.readFile as54115}
          ${builtins.readFile as32934}
          ${builtins.readFile as16509}
          ${builtins.readFile nonprefix}
          ${builtins.readFile nl}
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
  virtualisation.docker.enable = true;
}
