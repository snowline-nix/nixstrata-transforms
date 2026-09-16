{
  mkStep,

  accForEachElem,
  keepElemsIf,

  ...
}:
{
  prioritizeLowerStep = mkStep {
    identifier = "priorities.prioritizeLower";
    operation = { declarations, ... }:
      let
        minPriority =
          accForEachElem declarations
          9223372036854775807
          (min: valueObj:
            let priority = valueObj.priority; in
            if min < priority then min
            else priority
          );
      in
        keepElemsIf (valueObj: valueObj.priority == minPriority)
        declarations;
  };
}
