{lib, ...}:
with lib; {
  options = {
    username = mkOption {type = types.str;};
    name = mkOption {type = types.str;};
    email = mkOption {type = types.str;};
    gpgKey = mkOption {type = types.str;};
    gitIncludes = mkOption {type = types.listOf types.anything;};
    # Ideally there should be includeModule instead of types.anything, but its definition is bigger then this entire file
  };

  config = {
    username = "user";
    name = "Lorem Ipsum";
    email = "user@domain.tld";
    gpgKey = "aHR0cHM6Ly93d3cueW91dHViZS5jb20vd2F0Y2g/dj1kUXc0dzlXZ1hjUQ==";
    gitIncludes = [];
  };
}
