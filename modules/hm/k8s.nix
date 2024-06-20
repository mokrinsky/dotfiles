{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.yumi.k8s;
in {
  options.yumi.k8s.enable = mkEnableOption "Enable kubernetes tools deployment";

  config = mkIf cfg.enable {
    sops = {
      secrets = let
        konfPath = "${config.home.homeDirectory}/.kube/konfs/store";
      in {
        "kubeconfig/argolab".path = "${konfPath}/argolab_default.yaml";
        "kubeconfig/talos".path = "${konfPath}/admin@talos_talos.yaml";
      };
    };

    home = {
      packages = with pkgs; [
        argocd
        cilium-cli
        dyff # diff for yaml
        jqp # playground for jq
        konf
        krew
        kubectl
        kubernetes-helm
        talosctl
        terraform
        velero
      ];
    };

    programs = {
      fish = {
        shellInit = ''
          function konf -w konf-go
              set -f res (konf-go $argv)
              if string match -q 'KUBECONFIGCHANGE:*' $res
                  # this basically takes the line and cuts out the KUBECONFIGCHANGE Part
                  set -gx KUBECONFIG (string replace -r '^KUBECONFIGCHANGE:' "" ''$res)
              else
                  # this makes --help work
                  # because fish does not support bracketed vars, we use printf instead
                  printf "%s\n" ''$res
              end
          end
          function konf_cleanup
              konf-go cleanup
          end
          trap konf_cleanup EXIT
          set -x KUBECONFIG (konf-go --silent set -)
        '';
      };
    };
  };
}
