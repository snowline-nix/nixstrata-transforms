{ steps, ... }:
{ isAttrset, ... }:
let inherit (builtins) attrNames; in
{
  defaultTypeCheck = steps.mkConditionalTypeCheckStep {
    identifier = "default";
    operation = { valueObj, context, ... }: context.type.forceCheck valueObj.value;
  };

  customTypeCheck = check: steps.mkConditionalTypeCheckStep {
    identifier = "custom";
    operation = { valueObj, ... }: check valueObj.value;
  };

  lazyStructTypeCheck = structAttrNames: steps.mkConditionalTypeCheckStep {
    identifier = "lazyStruct";
    operation = { valueObj, ... }:
      let v = valueObj.value; in
      isAttrset v && attrNames v == structAttrNames;
  };
}
