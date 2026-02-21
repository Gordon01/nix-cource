{
  description = "Nix course slides (Marp)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nodejs
          pkgs.marp-cli
        ];
      };

      packages.${system}.intro = pkgs.stdenv.mkDerivation {
        name = "intro";
        src = ./slides;

        buildInputs = [ pkgs.marp-cli ];

        buildPhase = ''
          marp intro.md --html -o index.html
        '';

        installPhase = ''
          mkdir -p $out
          cp index.html $out/
        '';
      };
    };
}