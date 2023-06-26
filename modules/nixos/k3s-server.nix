_: {
  services = {
    k3s = {
      enable = true;
      extraFlags = "--disable traefik --disable local-storage --disable metrics-server --flannel-backend=none --disable-network-policy";
    };
  };
}
