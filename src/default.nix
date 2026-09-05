inputs:
{

  lib = let

    sublibs = {
      constructors = import ./constructors.nix sublibInputs;
      errors = import ./errors.nix sublibInputs;
      merging = import ./merging.nix sublibInputs;
      priorities = import ./priorities.nix sublibInputs;
      typeCheck = import ./typeCheck.nix sublibInputs;
      valueObject = import ./valueObject.nix sublibInputs;
    };

    sublibInputs = inputs.nixlib.lib // sublibs;
  in
    sublibs // {
      inherit (sublibs.constructors)
        mkInitialInputs
        mkTransformStep
        remapOutputStep
        ;
    };

}
