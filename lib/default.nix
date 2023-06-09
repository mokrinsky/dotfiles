{inputs, ...}: {
  mkConfiguration = {
    name,
    modules,
    system,
    specialArgs,
    builder,
  }:
    builder {
      inherit specialArgs system;
      modules =
        ["${inputs.self}/hosts/${name}"]
        ++ modules;
    };
}
