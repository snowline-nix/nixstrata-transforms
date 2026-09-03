inputs:
{

  lib = let

    sublibs = {
      errors = import ./errors.nix sublibInputs;
      merging = import ./merging.nix sublibInputs;
      priorities = import ./priorities.nix sublibInputs;
      transforms = import ./transforms.nix sublibInputs;
      typeCheck = import ./typeCheck.nix sublibInputs;
      valueObject = import ./valueObject.nix sublibInputs;
    };

    sublibInputs = inputs.nixlib.lib // sublibs;
  in
    sublibs;

}
