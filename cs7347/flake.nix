{
  description = "CS7347 Natural Language Processing";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/d189bf92f9be23f9b0f6c444f6ae29351bb7125c";
    utils = { url = "github:numtide/flake-utils"; };
    compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, utils, compat }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        python = pkgs.python39;
        projectDir = ./.;
        overrides = pkgs.poetry2nix.overrides.withDefaults (final: prev: {
          # Python dependency overrides go here
        });
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            # python
            (pkgs.poetry2nix.mkPoetryEnv {
              inherit python projectDir overrides;
            })
            pkgs.python39Packages.poetry
            python

            # tex
            (pkgs.texlive.combine {
              inherit (pkgs.texlive)
                scheme-small
                latexmk
                latexindent

                adjustbox
                collectbox
                ;
            })
          ];
        };
      });
}
