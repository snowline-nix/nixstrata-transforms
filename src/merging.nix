{
  transforms,
  merging,
  errors,

  elemAt,
  lengthOfList,
  joinLists,

  ...
}:
{
  mkMergeMethodStep = { type, mergeMethod }:
    transforms.mkTransformStep {
      type = "mergeMethod.${type}";
      evalPrev = { prevOutput, evalInputs, _type, ... }:
        let
          nOfValues = lengthOfList prevOutput;
          missingValueErr = errors.mergeErr {
            message = "no value declerations";
            valueObjs = prevOutput;
            transformType = _type;
            inherit evalInputs;
          };
        in
          if nOfValues < 1 then missingValueErr else
          mergeMethod {
            valueObjs = prevOutput;
            transformType = _type;
            inherit evalInputs;
          };
    };

  # -------------------------
  # Merge Methods
  # -------------------------

  joinLists = merging.mkMergeMethodStep {
    type = "joinLists";
    mergeMethod = { valueObjs, ... }: joinLists valueObjs;
  };

  noMerge = merging.mkMergeMethodStep {
    type = "noMerge";
    mergeMethod = { valueObjs, evalInputs, transformType, ... }:
      if lengthOfList valueObjs == 1 then (elemAt 0 valueObjs).value else
      errors.mergeErr {
        message = "type ${evalInputs.expectedType.name} does not support merging multiple value declarations";
        inherit valueObjs evalInputs transformType;
      };
  };

  staticValue = value: merging.mkMergeMethodStep {
    type = "staticValue";
    mergeMethod = _: value;
  };

  staticNull = merging.staticValue null;
}
