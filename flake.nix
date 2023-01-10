{
  inputs = {
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    flake-utils.url = "github:numtide/flake-utils";
    melange.url = "github:laaksonel/melange/main";
    dream2nix.url = "github:nix-community/dream2nix";

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, melange, nixpkgs, dream2nix, gitignore }@inputs:
    let
      dream2nixOutputs = dream2nix.lib.makeFlakeOutputs {
        systems = [flake-utils.lib.defaultSystems];
        config.projectRoot = ./.;
        source = gitignore.lib.gitignoreSource ./.;
        projects = ./projects.toml;
      };
      customOutput = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs =
            nixpkgs.legacyPackages.${system}.extend(self: super: {
              ocamlPackages = super.ocaml-ng.ocamlPackages_5_0;
            });
        in {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs-18_x
              reason
            ] ++ (with pkgs.ocamlPackages; [
              melange.packages.${system}.mel
              melange.packages.${system}.melange
              melange.packages.${system}.meldep
              dune_3
              ocaml
              ocaml-lsp
              ocamlformat-rpc
              merlin
              utop
            ]);

            shellHook = ''
              npm install && \
              ln -sfn ${melange.packages.${system}.melange}/lib/melange/runtime node_modules/melange
            '';
          };

          defaultPackage = dream2nixOutputs.apps.${system}.default;
        });
    in nixpkgs.lib.recursiveUpdate dream2nixOutputs customOutput;
}
