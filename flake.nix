{
  description = "General-purpose flake for small nix shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in
  {
    devShells."x86_64-linux" = {
      default = pkgs.mkShell { buildInputs = []; };

      "image_optim" = import ./image_optim/shell.nix { inherit pkgs; };
      "spotdl" = import ./spotdl/shell.nix { inherit pkgs; };
      "yt-dlp" = import ./yt-dlp/shell.nix { inherit pkgs; };
    };
  };
}
