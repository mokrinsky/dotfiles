{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
      wireguard-go
      wireguard-tools
      yubikey-manager
      openconnect
      gopass
      openssh
    ];
  };

  programs = {
    ssh = {
      enable = true;
      serverAliveInterval = 15;
      includes = [
        "config_job"
        "config_personal"
        "config_f5"
      ];
      matchBlocks = {
        "*" = {
          remoteForwards = [
            {
              bind.port = 3128;
              host.address = "127.0.0.1";
              host.port = 3128;
            }
          ];
          extraOptions = {
            PubkeyAcceptedKeyTypes = "+ssh-rsa,ssh-dss";
          };
        };
      };
    };
    gpg = {
      enable = true;
      homedir = config.xdg.configHome + "/gnupg";
      settings = {
        no-emit-version = true;
        no-greeting = true;
      };
    };
  };
}
