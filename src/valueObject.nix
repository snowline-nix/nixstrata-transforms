{ transforms, errors, ... }:
{
  defaultValueObj = transforms.remapOutputStep {
    type = "defaultValueObj";
    evalElem = { elem, evalInputs, transformType, ... }:
      let
        valueObj =
          if (elem._type or null) == default._type then default // elem
          else default // { value = elem; };

        default = {
          _type = "valueObject";
          staticType = null;
          priority = 500;
          value = errors.noValueErr {
            inherit valueObj evalInputs transformType;
          };
        };
      in
        valueObj;
  };
}
