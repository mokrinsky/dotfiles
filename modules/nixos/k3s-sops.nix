_: {
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
}
