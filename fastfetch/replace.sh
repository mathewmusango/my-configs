#!/usr/bin/env sh
# Replace the live fastfetch config with a design's config (no symlinks).
# Usage: ./replace.sh <design-dir>   e.g. ./replace.sh 02-tree
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$1" ]; then
    echo "Usage: $0 <design-dir>   (e.g. $0 02-tree)"
    echo "Available designs:"
    ls "$DIR"
    exit 1
fi

SRC="$DIR/$1/config.jsonc"
if [ ! -f "$SRC" ]; then
    echo "error: no config at $SRC" >&2
    exit 1
fi

mkdir -p "$HOME/.config/fastfetch"
cp "$SRC" "$HOME/.config/fastfetch/config.jsonc"
echo "replaced ~/.config/fastfetch/config.jsonc with '$1'"
