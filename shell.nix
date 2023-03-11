{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    just
  ];
}
