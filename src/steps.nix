{
  errors, steps,

  mkStep,

  lengthOfList,
  remapElems,

  ...
}:
{
  mkTypeTransformStep = { identifier, operation, description ? null }: let
    transform = mkStep {
      inherit identifier description;
      operation = { context, ... }@inputs: {
        inherit context transform;
        declarations = operation inputs;
      };
    };
  in
    transform;

  mkTypeRemapStep = { identifier, operation, description ? null }: let
    transform = mkStep {
      inherit identifier description;
      operation = { context, declarations, ... }: {
        inherit context transform;
        declarations =
          remapElems declarations
          (decl: operation { inherit context transform declarations decl; });
      };
    };
  in
    transform;

  mkConditionalTypeCheckStep = { identifier, operation, description ? null }: let
    transform = steps.mkTypeRemapStep {
      inherit description;
      identifier = "typeCheck.${identifier}";
      operation = { context, declarations, decl, ... }:
        let inputs = { inherit context transform declarations; valueObj = decl; }; in
        if operation inputs then decl else errors.typeCheckErr inputs;
    };
  in
    transform;

  mkTypeMergeMethodStep = { identifier, operation, description ? null }: let
    transform = steps.mkTypeTransformStep {
      inherit description;
      identifier = "mergeMethod.${identifier}";
      operation = { context, declarations, ... }:
        let inputs = { inherit context transform; valueObjs = declarations; }; in
        if lengthOfList declarations > 0 then operation inputs
        else errors.mergeErr.missingDeclarationsErr inputs;
    };
  in
    transform;

  mkStaticTypeMergeMethodStep = value: steps.mkTypeMergeMethodStep {
    identifier = "staticValue";
    operation = _: value;
  };
}
