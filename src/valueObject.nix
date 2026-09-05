{ transforms, errors, ... }:
{
  defaultValueObj = transforms.remapOutputStep {
    type = "defaultValueObj";
    evalElem = { elem, context, currentTransformType, ... }:
      let
        default = {
          _type = "valueObject";
          staticType = null;
          priority = 500;
          value = errors.noValueErr {
            inherit context;
            valueObj = elem;
            transformType = currentTransformType;
          };
        };
      in
        if (elem._type or null) == default._type then default // elem
        else default // { value = elem; };
  };
}
