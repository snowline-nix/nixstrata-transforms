{
  mkTypeTransformInit = {
    values,
    type ? null,
    module ? null,
    option ? null,
    path ? [],
    transform ? "initializer.typeTransform",
    ...
  }@inputs: {
    context = {
      ${if inputs ? type then "type" else null} = type;
      ${if inputs ? module then "module" else null} = module;
      ${if inputs ? option then "option" else null} = option;
      inherit path;
    };
    inherit transform;
    declarations = values;
  };
}
