{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      (python3.withPackages (p:
        with p; [
          pip
          numpy
          yt-dlp
          black
          pkgs.ansible-lint
          pylint
          yamllint
          ansible
          virtualenv
          pika
          nur.repos.yumi.ovirt-engine-sdk-python
        ]))
    ];
  };
}
