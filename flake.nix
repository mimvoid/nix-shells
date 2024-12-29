{
  description = "General-purpose flake for small nix shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      allSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;

      toSystems = passPkgs: allSystems (system:
        passPkgs (import nixpkgs { inherit system; })
      );
    in
    {
      devShells = toSystems (pkgs: {
        default = pkgs.mkShell { packages = [ ]; };

        "image_optim" = import ./image_optim/shell.nix { inherit pkgs; };
        "spotdl" = import ./spotdl/shell.nix { inherit pkgs; };
        "yt-dlp" = import ./yt-dlp/shell.nix { inherit pkgs; };
      });
    };
}
