{
  mkTypeTransformInit = {
    values,
    type ? null,
    module ? null,
    option ? null,
    path ? null,
    transform ? "initializer.typeTransform",
    ...
  }@inputs: {
    context = {
      ${if inputs ? option then "type" else null} = type;
      ${if inputs ? option then "option" else null} = option;
      ${if inputs ? module then "module" else null} = module;
      ${if inputs ? path then "path" else null} = path;
    };
    inherit transform;
    declarations = values;
  };
}
