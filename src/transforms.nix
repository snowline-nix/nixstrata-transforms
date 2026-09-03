{
  transforms,

  remapElems,

  ...
}:
{
  mkTransformStep = { type, evalPrev }:
    { _type, evalInputs, prevOutput } @prevStep: {
      _type = "transformStep.${type}";
      inherit evalInputs;
      prevOutput = evalPrev prevStep;
    };

  remapOutputStep = { type, evalElem }:
    transforms.mkTransformStep {
      inherit type;
      evalPrev = { prevOutput, evalInputs, _type, ... }:
        remapElems prevOutput
        (elem: evalElem { inherit evalInputs elem; transformType = _type; });
    };
}
