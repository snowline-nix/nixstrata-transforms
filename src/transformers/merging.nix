{
  errors,
  steps,

  elemAt,
  joinLists,
  lengthOfList,
  remapElems,

  ...
}:
{
  joinLists = steps.mkTypeMergeMethodStep {
    identifier = "joinLists";
    operation = { valueObjs, ... }: joinLists (remapElems valueObjs (v: v.value));
  };

  noMerge = steps.mkTypeMergeMethodStep {
    identifier = "noMerge";
    operation = { valueObjs, ... }@inputs:
      if lengthOfList valueObjs == 1 then (elemAt 0 valueObjs).value else
      errors.mergeErr.mergingUnsupportedErr inputs;
  };

  staticNull = steps.mkStaticTypeMergeMethodStep null;
}
