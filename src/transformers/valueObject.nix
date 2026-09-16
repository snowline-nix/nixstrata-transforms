{ steps, errors, ... }:
{
  defaultValueObj = steps.mkTypeRemapStep {
    identifier = "valueObject.default";
    operation = { context, decl, ... }@inputs: let
      default = {
        _type = "valueObject";
        priority = context.option.priority or 500;
        value = errors.noValueErr inputs;
      };
    in
      if (decl._type or null) == default._type then default // decl
      else default // { value = decl; };
  };
}
