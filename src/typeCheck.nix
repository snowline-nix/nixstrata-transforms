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

  defaultTypeCheck = typeCheck.mkTypeCheckStep {
    type = "defaultTypeCheck";
    typeCheckMethod = { valueObj, context, ... }@inputs:
      if context.expectedType.forceCheck valueObj.value
      then valueObj else errors.typeCheckErr inputs;
  };
}
