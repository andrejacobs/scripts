#!/bin/bash
# Download Youtube videos and extract the audio to m4a

set -eu
set -o pipefail

# Requirements:
# yt-dlp            brew install yt-dlp
# ffmpeg            brew install ffmpeg
# AtomicParsley     brew install AtomicParsley (needed for embed thumbnail)

function usage() {
    echo "download.sh <play list URL> <start index> <delay>"
}

if [ "$#" -ne 3 ]; then
    echo "Wrong number of parameters"
    usage
    exit 1
fi

# Used the Chrome extension: Get cookies.txt LOCALLY
COOKIES="cookies.txt"
USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

if [ ! -f "${COOKIES}" ]; then
    echo "Expected a ${COOKIES} file"
    exit 1
fi

# $1 The playlist URL
# $2 The playlist start item
# $3 The number of seconds to wait before each download starts
function download_playlist_audio() {
    echo "Downloading playlist: $1"
    # See https://github.com/yt-dlp/yt-dlp for more details
    yt-dlp --playlist-start $2 --sleep-interval $3 --user-agent "${USER_AGENT}" --cookies "${COOKIES}" --extract-audio --audio-format m4a --embed-thumbnail --keep-video -o "%(playlist)s/%(playlist_index)s - %(title)s - %(channel)s.%(ext)s" $1
}

download_playlist_audio $1 $2 $3
