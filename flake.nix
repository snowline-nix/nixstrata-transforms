{
  description = "nixstrata-transforms";

  inputs.nixlib-general.url = "git+https://github.com/zudww/nixlib-general?ref=v0.3.0-a1";
  inputs.nixllization.url = "git+https://github.com/snowline-nix/nixllization?ref=v0.1.0-a3";

  outputs = _: import ./src _;
}
