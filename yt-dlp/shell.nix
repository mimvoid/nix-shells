{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    (yt-dlp.override {
      atomicparsleySupport = false;
      rtmpSupport = false;
    })
  ];

  shellHook = ''
    echo -e "Download OPUS audio with jpg thumbnail: yt-audio <url>"
    alias yt-audio="yt-dlp --downloader aria2c --check-formats -x --audio-format opus --embed-thumbnail --embed-metadata --no-embed-chapters --no-embed-info-json --parse-metadata ':(?P<meta_synopsis>)' --write-subs --sub-langs 'en.*,ja' --convert-subs lrc --convert-thumbnails jpg"
  '';
}
