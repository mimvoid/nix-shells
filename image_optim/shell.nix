{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [ image_optim ];

  shellHook =
    ''
      ln -s ${./image_optim.yaml} ~/.config/image_optim.yaml
    '';
}
