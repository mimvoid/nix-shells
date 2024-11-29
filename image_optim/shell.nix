{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [ image_optim ];

  shellHook =
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
    ''
      ln -s ${image_optim_config} ~/.config/image_optim.yaml
    '';
}
