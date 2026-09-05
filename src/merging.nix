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
      evalPrev = { output, context, currentTransformType, ... }:
        let
          nOfValues = lengthOfList output;
          missingValueErr = errors.mergeErr {
            message = "no value declerations";
            valueObjs = output;
            transformType = currentTransformType;
            inherit context;
          };
        in
          if nOfValues < 1 then missingValueErr else
          mergeMethod {
            valueObjs = output;
            transformType = currentTransformType;
            inherit context;
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
    mergeMethod = { valueObjs, context, transformType, ... }:
      if lengthOfList valueObjs == 1 then (elemAt 0 valueObjs).value else
      errors.mergeErr {
        message = "type ${context.expectedType.name} does not support merging multiple value declarations";
        inherit valueObjs context transformType;
      };
  };

  staticValue = value: merging.mkMergeMethodStep {
    type = "staticValue";
    mergeMethod = _: value;
  };

  staticNull = merging.staticValue null;
}
