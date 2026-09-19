{ toRepr, remapElems, joinStringsSep, ... }:
let
  getPath = path:
    builtins.substring 1 (-1)
    (
      joinStringsSep ""
      (remapElems path (
        { type, address }:
          if type == "attribute" then ".${address}"
          else if type == "element" then "[${address}]"
          else ".({${type}.${address})"
      ))
    );

  mkModuleError = { transform, context, content, summary, pathInSummary ? true }: let
    hasPath = context ? path;
    path = getPath context.path;
    summary' = summary + (if pathInSummary && hasPath then " at `${path}`" else "");
    at = (if context ? module then "\nIn: ${context.module.sourcePath}\n" else "") + (if hasPath then "\nAt: `${path}`\n" else "");
  in
    throw ''
      ${summary'}
      While evaluating: '${transform.identifier}'
      ${at}
      ${content { inherit hasPath path; }}

      error: ${summary'}
    '';
in
{
  noValueErr = { context, transform, ... }: mkModuleError {
    inherit context transform;
    summary = "no value was declared";
    content = { hasPath, path, ... }: ''
      ${
        if context ? type
        then "Type (${context.type.name}) requires a value to evaluate."
        else "Transform step ('${transform.identifier}') requires a value to evaluate"
      }

      No value was declared for one of the declarations${if hasPath then " of ${path}" else ""}.
    '';
  };

  # Requires `context.type` to be a type.
  typeCheckErr = { context, valueObj, transform, ... }: let
    type = context.type;
    value = toRepr valueObj.value;
  in mkModuleError {
    inherit context transform;
    summary = "invalid value for type '${type.name}'";
    content = _: ''
      This type requires a value conforming to:

      '${type.name}'${if type ? description then " - ${type.description}" else ""}

      Full type: ${type.fullDefinitionName}

      The value `${value}` does not conform to the${if context ? option then " option" else ""} type '${type.name}'.
    '';
  };

  mergeErr.missingDeclarationsErr = { context, transform, ... }: mkModuleError {
    inherit context transform;
    summary = "no values were declared";
    content = { hasPath, path, ... }: ''
      No values were declared${if hasPath then " for ${path}" else ""}.
    '';
  };

  mergeErr.mergingUnsupportedErr = { context, transform, ... }: let
    typeName = context.type.name;
    transformId = transform.identifier;
    genMsg = capitalized:
      if context ? type
      then "${if capitalized then "T" else "t"}ype '${typeName}'"
      else "${if capitalized then "M" else "m"}erge method '${transformId}'"
      ;
  in mkModuleError {
    inherit context transform;
    pathInSummary = false;
    summary = (genMsg false) + "does not support merging";
    content = { hasPath, path, ... }: ''
      ${genMsg true} does not support merging multiple value declarations.

      No values were declared${if hasPath then " for ${path}" else ""}.
    '';
  };
}
