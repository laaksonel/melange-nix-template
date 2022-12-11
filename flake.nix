{
  inputs = {
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    flake-utils.url = "github:numtide/flake-utils";
    melange.url = "github:melange-re/melange";
  };

  outputs = { self, flake-utils, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
          (self: super: {
            ocamlPackages = super.ocaml-ng.ocamlPackages_4_14;
          })
          inputs.melange.overlays.default
        ];
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs-18_x
            reason
          ] ++ (with pkgs.ocamlPackages; [
            melange
            mel
            dune_3
            ocaml
          ]);

          shellHook = ''
            npm install && \
            ln -sfn ${pkgs.ocamlPackages.melange}/lib/melange/runtime node_modules/melange
          '';
        };
      });
}
