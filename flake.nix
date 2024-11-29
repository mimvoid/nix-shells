{
  description = "General-purpose flake for small nix shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell { packages = [ ]; };

        "image_optim" = import ./image_optim/shell.nix { inherit pkgs; };
        "spotdl" = import ./spotdl/shell.nix { inherit pkgs; };
        "yt-dlp" = import ./yt-dlp/shell.nix { inherit pkgs; };
      });
    };
}
