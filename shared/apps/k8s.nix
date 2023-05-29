{
  pkgs,
  config,
  ...
}: {
  sops = {
    secrets = let
      konf = "${config.home.homeDirectory}/.kube/konfs/store";
    in {
      "kubeconfig/dbo".path = "${konf}/dbo_kvantera.yaml";
      "kubeconfig/nl-k3s".path = "${konf}/nl-k3s_nl-k3s.yaml";
    };
  };

  home = {
    packages = with pkgs; [
      argocd
      konf
      kubectl
      kubernetes-helm
      kyverno
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
}
