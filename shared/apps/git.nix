{
  config,
  pkgs,
  configRoot,
  ...
}: {
  programs.git = {
    enable = true;
    userName = configRoot.name;
    userEmail = configRoot.email;
    signing = {
      key = configRoot.gpgKey;
      signByDefault = true;
    };
    lfs = {
      enable = true;
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      push = {
        autoSetupRemote = true;
      };
    };
    includes = configRoot.gitIncludes;
  };
}
