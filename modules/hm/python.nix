{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.yumi.python;
in {
  options.yumi.python = {
    enable = mkEnableOption "Install python with modules";
    withAnsible = mkEnableOption "Install ansible packages";
  };

  config = mkIf cfg.enable {
    sops = mkIf cfg.withAnsible {
      secrets = {
        ansibleCfg.path = "${config.xdg.configHome}/ansible.cfg";
      };
    };

    programs.pyenv.enable = true;

    home = {
      sessionVariables = mkIf cfg.withAnsible {
        ANSIBLE_CONFIG = "${config.xdg.configHome}/ansible.cfg";
      };
      # packages = with pkgs; [
      #   (python3.withPackages (
      #     p:
      #       with p;
      #         [
      #           pika
      #           pip
      #           virtualenv
      #           yt-dlp
      #           pynetbox
      #         ]
      #         ++ optionals cfg.withAnsible (with p; [
      #           ansible-core
      #           nur.repos.yumi.ovirt-engine-sdk-python
      #         ])
      #   ))
      # ];
    };
  };
}
