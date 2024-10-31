{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    spotdl
  ];

  shellHook = ''
    echo -e "Basic usage: spotdl <song url>\nDocumentation: https://spotdl.readthedocs.io"
    alias spotdl="spotdl --audio {youtube-music,youtube} --lyrics {musixmatch,synced,genius,azlyrics} --generate-lrc --bitrate disable --format opus --restrict ascii"
  '';
}
