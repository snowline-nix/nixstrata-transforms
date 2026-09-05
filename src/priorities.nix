{
  transforms,

  accForEachElem,
  keepElemsIf,

  ...
}:
{
  prioritizeLowerStep = transforms.mkTransformStep {
    type = "prioritizeLowerStep";
    evalPrev = { output, ... }:
      let
        minPriority =
          accForEachElem output
          9223372036854775807
          (min: valueObj:
            let priority = valueObj.priority; in
            if min < priority then min
            else priority
          );
      in
        keepElemsIf (valueObj: valueObj.priority == minPriority)
        output;
  };
}
