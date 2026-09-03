{
  transforms,
  typeCheck,
  errors,

  remapElems,

  ...
}:
{
  mkTypeCheckStep = { type, typeCheckMethod }:
    transforms.mkTransformStep {
      type = "typeCheck.${type}";
      evalPrev = { prevOutput, evalInputs, _type, ... }:
        remapElems prevOutput
        (valueObj:
          let
            result = typeCheckMethod {
              inherit evalInputs valueObj;
              transformType = _type;
            };
          in
          if result != result then result else result
        );
    };

  defaultTypeCheck = typeCheck.mkTypeCheckStep {
    type = "defaultTypeCheck";
    typeCheckMethod = { evalInputs, valueObj, ... }@typeCheckMethodInputs:
      let
        passedTypeCheck = evalInputs.expectedType.forceCheck valueObj.value;
      in
        if passedTypeCheck then valueObj
        else errors.typeCheckErr typeCheckMethodInputs;
  };
}
