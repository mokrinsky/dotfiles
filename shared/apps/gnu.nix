{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      nur.repos.yumi.coreutils
      findutils
      gawk
      gnugrep
    ];
  };
}
