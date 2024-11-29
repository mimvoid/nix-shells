{
  pkgs ? import <nixpkgs> { },
}:
let
  aliases = {
    # Download in OPUS format with lyrics
    spotdl-opus = pkgs.writeShellScriptBin "spotdl-opus" ''
      spotdl --audio {youtube-music,youtube} \
      --lyrics {musixmatch,synced,genius,azlyrics} --generate-lrc \
      --bitrate disable \
      --format opus \
      "$@"
    '';
  };
in
pkgs.mkShell {
  packages = with pkgs;
    [
      spotdl
    ]
    ++ [
      aliases.spotdl-opus
    ];

  shellHook = ''
    echo -e "Basic usage: spotdl <song url>\nDocumentation: https://spotdl.readthedocs.io"
  '';
}
