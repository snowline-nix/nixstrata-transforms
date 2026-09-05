{
  constructors,

  remapElems,

  ...
}:
{
  mkTransformInputs = { type, context, input }: {
    transformType = "transformStep.${type}";
    inherit context;
    output = input;
  };

  mkTransformStep =
    { type, evalPrev }:
    { context, ... }@prevStep:
    let
      curStep = constructors.mkTransformInputs {
        inherit type context;
        input =
          evalPrev
          (prevStep // { currentTransformType = curStep.transformType; });
      };
    in
      curStep;

  remapOutputStep = { type, evalElem }:
    constructors.mkTransformStep {
      inherit type;
      evalPrev = { output, ... }@prevStep:
        remapElems output
        (elem: evalElem (prevStep // { elem = elem; }));
    };
}
