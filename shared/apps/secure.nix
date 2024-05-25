{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [
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
