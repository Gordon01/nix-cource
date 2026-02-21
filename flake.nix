{
  description = "Nix course slides (Marp)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.intro = pkgs.stdenv.mkDerivation {
        name = "intro";
        src = ./slides;

        nativeBuildInputs = with pkgs; [
          chromium
          fontconfig
          marp-cli
          noto-fonts
        ];

        buildPhase = ''
          export HOME=$TMPDIR
          export CHROME_PATH=${pkgs.chromium}/bin/chromium

          marp intro.md --html -o index.html
          marp intro.md --pdf -o intro.pdf
        '';

        installPhase = ''
          mkdir -p $out
          cp index.html $out/
          cp intro.pdf $out/
        '';
      };
    };
}
