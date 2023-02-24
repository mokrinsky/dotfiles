{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "mokrinsky";
      repo = "nvim-config";
      rev = "HEAD";
      sha256 = "sha256-pSm4X3jR1g68IBTJLYyD4gsufFd5vEOPw1vHJYm9PDU=";
    };
  };

  programs.neovim = {
    withRuby = false;
    withPython3 = false;
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # I prefer using Mason, but some packages are not present in here
      alejandra
    ];
  };
}
