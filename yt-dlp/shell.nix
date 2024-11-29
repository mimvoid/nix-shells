{ pkgs ? import <nixpkgs> {} }:
let
  # Remove unneeded dependencies
  yt-dlp = pkgs.yt-dlp.override {
    rtmpSupport = false;
  };

  aliases = {
    # Download audio-only with aria2c
    yt-audio = pkgs.writeShellScriptBin "yt-audio"
      ''
        yt-dlp \
        --downloader aria2c \
        --check-formats -x --audio-format opus \
        --no-embed-chapters --no-embed-info-json \
        --embed-metadata --parse-metadata ':(?P<meta_synopsis>)' \
        --write-subs --sub-langs 'en.*,ja' --convert-subs lrc \
        --embed-thumbnail --convert-thumbnails jpg \
        "$@"
      '';
  };
in
pkgs.mkShell {
  name = "yt-dlp shell";

  packages = [
    yt-dlp
    aliases.yt-audio
  ];

  shellHook = ''
    echo -e "Download OPUS audio with jpg thumbnail: yt-audio <url>"
  '';
}
