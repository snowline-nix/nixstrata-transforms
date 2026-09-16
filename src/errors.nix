{ toString, ... }:
let
  getDecls = context:
    if context ? module
    then "\nThe definition was evaluated at:\n\t${context.module.source}\n"
    else "";
in
{
  noValueErr = { context, transform, ... }: let
    path = if context ? path then " for `${context.path}`" else "";
    summary = "no value was declared${path}";
  in
    throw ''
      ${summary}
      ${getDecls context}
      ${
        if context ? type
        then "This type requires a value to evaluate.\n\nType:\n\t${context.type.name}"
        else "This transform step (`${transform.identifier}`) requires a value to evaluate"
      }

      No values were declared${path}.

      error: ${summary}
    '';

  # Requires `context.type` to be a type.
  typeCheckErr = { context, valueObj, ... }: let
    hasPath = context ? path;
    type = context.type;
    summary = "value does not conform to type `${type.name}`${if hasPath then " at `${context.path}`" else ""}";
    value = toString valueObj.value;
  in
    throw ''
      ${summary}
      ${getDecls context}
      This type requires a value conforming to:
        ${type.fullDefinitionName}
      ${
        if type.description != null then "\n${type.description}\n" else ""
      }
      The value `${value}` does not conform to the${if context ? option then " option" else ""} type `${type.name}`.
      ${
        if hasPath then "At: `${context.path} = ${value}`" else ""
      }
      error: ${summary}
    '';

  mergeErr.missingDeclarationsErr = { context, transform, ... }: let
    hasPath = context ? path;
    path = context.path;
    summary = "no value declarations provided for merging${if hasPath then " at `${path}`" else ""}";
  in
    throw ''
      ${summary}
      ${getDecls context}
      ${
        if context ? type
        then "Type ${context.type.name} has no values to work with."
        else "Merge method ${transform.identifier} has no values to work with."
      }
      ${if hasPath then "\nAt: `${path}`\n" else ""}
      error: ${summary}
    '';

  mergeErr.mergingUnsupportedErr = { context, transform, ... }: let
    hasPath = context ? path;
    path = context.path;
    summary = "type ${context.type.name} does not support merging";
  in
    throw ''
      ${summary}
      ${getDecls context}
      ${
        if context ? type
        then "Type ${context.type.name} does not support merging of multiple value declarations."
        else "Merge method `${transform.identifier}` does not support merging of multiple values."
      }
      ${if hasPath then "\nAt: `${path}`\n" else ""}
      error: ${summary}
    '';
}
