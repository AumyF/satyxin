{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.satyxin.url = "github:aumyf/satyxin";
  inputs.satysfi-tools.url = "github:SnO2WMaN/satysfi-tools-nix";
  inputs.uline = {
    url = "github:puripuri2100/SATySFi-uline";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, satyxin, satysfi-tools, uline }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system;
        overlays = [
          satyxin.overlay
          satysfi-tools.overlay
        ];
      };
      in
      rec {
        packages = flake-utils.lib.flattenTree rec {
          uline = pkgs.satyxin.buildPackage {
            name = "satysfi-uline";
            src = uline;
            path = "uline.satyh";
          };
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
