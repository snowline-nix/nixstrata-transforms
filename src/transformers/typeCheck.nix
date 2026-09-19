{ steps, ... }:
{
  defaultTypeCheck = steps.mkConditionalTypeCheckStep {
    identifier = "default";
    operation = { valueObj, context, ... }: context.type.forceCheck valueObj.value;
  };

  customTypeCheck = check: steps.mkConditionalTypeCheckStep {
    identifier = "custom";
    operation = { valueObj, ... }: check valueObj.value;
  };
}
