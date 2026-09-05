{
  errors,

  elemAt,
  joinStringsSep,
  joinStrings,
  remapElems,
  tailElems,
  toRepr,

  ...
}:
let
  prettifyList = list:
    "[\n"
    + ( joinStrings (remapElems (v: "  " + toRepr v + "\n") list) )
    + "]";
in
{
  mkErrorMessage = lines: throw ''

    ------------ EXTRA INFO ------------
    ${joinStringsSep "\n" (tailElems lines)}
    ------------------------------------

    error: ${elemAt 0 lines}
  '';

  # -------------------------
  # Errors
  # -------------------------

  mergeErr = {
    message,
    valueObjs,
    context,
    transformType,
    ...
  }:
    let type = context.expectedType; in
    errors.mkErrorMessage [
      (message + " (mergeErr)")
      "transform: ${transformType}"
      "values: \n${prettifyList (remapElems valueObjs (v: v.value))}\n"
      "full type: ${type.definitionName}"
      "type: ${type.name}"
      "error: mergeErr"
    ];

  noValueErr = {
    valueObj,
    context,
    transformType,
    ...
  }:
    let type = context.expectedType; in
    errors.mkErrorMessage [
      "no value declared for value definition"
      "expected full type: ${type.definitionName}\n"
      "expected type: ${type.name}"
      "transform: ${transformType}"
      "value definition: ${toRepr valueObj}"
      "error: noValueErr"
    ];

  typeCheckErr = {
    valueObj,
    context,
    transformType,
    ...
  }:
    let type = context.expectedType; in
    errors.mkErrorMessage [
      "value does not conform to type (${type.name})"
      "transform: ${transformType}"
      "error: noValueErr"
      "expected full type: ${type.definitionName}\n"
      "got value: ${toRepr valueObj.value}"
      "expected type: ${type.name}"
    ];
}
