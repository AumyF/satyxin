# satyxin

Satyxin helps you to build SATySFi documents with Nix.

- No Opam installation required
- Nix Flakes first
- Dependency version pinning achieved by `flake.lock`

## Example

```nix
{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  # Use satyxin as your flake's input
  inputs.satyxin.url = "github:aumyf/satyxin";
  # satysfi-language-server and satysfi-formatter
  inputs.satysfi-tools.url = "github:SnO2WMaN/satysfi-tools-nix";
  # SATySFi packages you use go here.
  # Note that almost all of them are not Nix flakes.
  inputs.uline = {
    url = "github:puripuri2100/SATySFi-uline";
    flake = false;
  };

  # Don't forget to add a parameter corresponding to inputs
  outputs = { self, nixpkgs, flake-utils, satyxin, satysfi-tools, uline }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system;
        # satyxin and satysfi-tools only provide nixpkgs overlay
        overlays = [
          satyxin.overlay
          satysfi-tools.overlay
        ];
      };
      in
      rec {
        packages = flake-utils.lib.flattenTree rec {
          # Use `buildPackage` to make a SATySFi package into a Nix package.
          # Pass a `path`, which specifies where the .satyh or .satyg files are.
          # Read the package's `Satyristes` file to know what to pass for `path`.
          # In the future, `buildPackage` will automatically read `Satyristes` and `path` will be no longer required.
          uline = pkgs.satyxin.buildPackage {
            name = "satysfi-uline";
            src = uline;
            path = "uline.satyh";
          };
          # Use `buildDocument` to build a SATySFi document.
          # Pass dependencies as `buildInputs`.
          demo = pkgs.satyxin.buildDocument {
            name = "satyxin-demo";
            src = ./.;
            filename = "demo.saty";
            buildInputs = [ packages.uline ];
          };
          default = demo;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            satysfi-formatter
            satysfi-language-server
          ];
        };
      }
    );
}
```
