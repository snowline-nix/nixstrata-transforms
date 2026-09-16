{
  nixlib-general,
  nixllization,

  ...
}:
{
  lib = let
    inputs = nixlib-general.lib // nixllization.lib // lib;
    lib = {
      errors = import ./errors.nix inputs;
      initializers = import ./initializers.nix;
      steps = import ./steps.nix inputs;
      transformers =
        import ./transformers/merging.nix inputs //
        import ./transformers/typeCheck.nix inputs //
        import ./transformers/priorities.nix inputs //
        import ./transformers/valueObject.nix inputs;
    };
  in
    lib;
}
