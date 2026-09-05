{
  transforms,
  typeCheck,
  errors,

  ...
}:
{
  mkTypeCheckStep = { type, typeCheckMethod }:
    transforms.remapOutputStep {
      type = "typeCheck.${type}";
      evalElem = { elem, context, currentTransformType, ... }:
        let
          result = typeCheckMethod {
            inherit context;
            valueObj = elem;
            transformType = currentTransformType;
          };
        in
          if result != result then result else result;
    };

  # -------------------------
  # Type Checks
  # -------------------------

  conditionTypeCheck = condition: typeCheck.mkTypeCheckStep {
    type = "conditionTypeCheck";
    typeCheckMethod = { valueObj, ... }@inputs:
      if condition inputs then valueObj
      else errors.typeCheckErr inputs;
  };

  defaultTypeCheck =
    typeCheck.conditionTypeCheck
    ({ context, valueObj, ... }: context.expectedType.forceCheck valueObj.value);
}
