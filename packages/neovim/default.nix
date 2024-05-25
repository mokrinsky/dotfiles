{
  pkgs,
  lib,
  makeWrapper,
  runCommandNoCC,
  neovim-unwrapped,
  sumneko-lua-language-server,
  stylua,
  selene,
  sqlite,
  statix,
  alejandra,
  nodePackages,
  tree-sitter,
  fd,
  ripgrep,
  yamlfmt,
  yamllint,
  codespell,
  shellcheck,
  commitlint,
  yaml-language-server,
  gopls,
  ansible-language-server,
  nil,
  pyright,
  ...
}:
runCommandNoCC "nvim" {nativeBuildInputs = [makeWrapper];} ''
  mkdir -p $out/bin
  makeWrapper ${neovim-unwrapped}/bin/nvim $out/bin/nvim \
    --set CC "gcc" \
    --set SQLITE_LIB_PATH "${sqlite.out}/lib/libsqlite3.so" \
    --prefix PATH : ${
    lib.makeBinPath [
      tree-sitter
      ripgrep
      fd
      # Linters
      alejandra
      statix
      selene
      stylua
      yamlfmt
      yamllint
      codespell
      shellcheck
      commitlint
      # Language servers
      yaml-language-server
      gopls
      ansible-language-server
      sumneko-lua-language-server
      nil
      pyright
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.typescript-language-server
      nodePackages.prettier
    ]
  }
''
