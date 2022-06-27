{
  description = "Build SATySFi documents using Nix";

  outputs = { self, ... }:
    rec {
      overlays.default = (import ./overlay.nix);
      overlay = overlays.default;

      templates.default = {
        path = builtins.filterSource (path: type: baseNameOf path == "flake.nix") "./example";
        description = "Build a SATySFi document.";
      };
    };
}
