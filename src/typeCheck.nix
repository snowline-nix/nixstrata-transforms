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
  # Condition Expressions
  # -------------------------

  ifElseHasStaticType = { valueType, nonStaticCheck, staticCheck }:
    if valueType == null then nonStaticCheck else staticCheck;

  hasValidStaticType = { valueObj, expectedType, nonStaticCheck }:
    let valueType = valueObj.staticType; in
    typeCheck.ifElseHasStaticType
    {
      inherit nonStaticCheck valueType;
      staticCheck = valueType.definitionName == expectedType.definitionName;
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
