{ steps, ... }:
{
  defaultTypeCheck = steps.mkConditionalTypeCheckStep {
    identifier = "default";
    operation = { valueObj, context }: context.type.forceCheck valueObj.value;
  };
}
