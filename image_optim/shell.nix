{ pkgs ? import <nixpkgs> {} }:
let
  image_optim_config = builtins.toFile "image_optim.yaml" # yaml
  ''
    allow_lossy: false
    verbose: true
    timeout: 120
    gifsicle:
      careful: true
    jpegoptim:
      strip: ['com', 'iptc', 'icc', 'xmp']
  '';
in
pkgs.mkShell {
  buildInputs = [ pkgs.image_optim ];

  shellHook = ''
    ln -s ${image_optim_config} ~/.config/image_optim.yaml
  '';
}
