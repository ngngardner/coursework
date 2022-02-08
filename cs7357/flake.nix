{
  description = "CS7357 Neural Nets and Deep Learning";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            # tex
            (pkgs.texlive.combine {
              inherit (pkgs.texlive)
                scheme-small
                latexmk
                latexindent

                esvect
                ;
            })
          ];
        };
      });
}
