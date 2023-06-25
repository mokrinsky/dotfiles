{
  pkgs,
  lib,
  config,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["nfs" "nfs4"];

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

  sops = {
    defaultSopsFile = ../../secrets/lab.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      k3s_token = {};
    };
  };

  system.stateVersion = "23.05";
  networking = {
    hostName = "k3";
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
      role = "agent";
      serverAddr = "https://k1.lab.kolya.it:6443";
      tokenFile = config.sops.secrets.k3s_token.path;
    };
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
