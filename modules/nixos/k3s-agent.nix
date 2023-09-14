{config, ...}: {
  services = {
    k3s = {
      enable = true;
      role = "agent";
      serverAddr = "https://k1.lab.local:6443";
      tokenFile = config.sops.secrets.k3s_token.path;
    };
  };
}
