{
  description = "nixstrata-transforms";

  inputs.nixlib.url = "github:zudww/nixlib-general/dev";

  outputs = _: import ./src _;
}
