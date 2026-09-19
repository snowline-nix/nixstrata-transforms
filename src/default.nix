{
  nixlib-general,
  nixllization,

  ...
}:
{
  lib = let
    ng = nixlib-general.lib;
    nl = nixllization.lib;
    lib = {
      errors = import ./errors.nix ng;
      initializers = import ./initializers.nix;
      steps = import ./steps.nix lib nl ng;
      transformers =
        import ./transformers/merging.nix lib ng //
        import ./transformers/typeCheck.nix lib ng //
        import ./transformers/priorities.nix lib ng //
        import ./transformers/valueObject.nix lib;

      inherit (lib.steps)
        mkTypeTransformStep
        mkTypeRemapStep
        mkConditionalTypeCheckStep
        mkTypeMergeMethodStep
        mkStaticTypeMergeMethodStep;
    };
  in
    lib;
}
