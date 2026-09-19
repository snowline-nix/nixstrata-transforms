{
  mkTypeTransformInit = {
    values,
    type ? null,
    module ? null,
    option ? null,
    path ? null,
    transform ? "initializer.typeTransform",
    ...
  }: {
    context = { inherit type module option path; };
    inherit transform;
    declarations = values;
  };
}
