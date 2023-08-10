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
      internalIPs = ["192.168.255.0/24"];
    };
    firewall = {
      checkReversePath = false;
      allowPing = true;
      allowedTCPPorts = [
        19333
        179
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
          ${builtins.readFile as63293}
          ${builtins.readFile as54115}
          ${builtins.readFile as32934}
          ${builtins.readFile as16509}
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
}
