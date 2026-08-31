#!/usr/bin/env sh
# Install the repo's .zshrc as the live config (no symlinks).
# Overwrites ~/.zshrc — back it up first if you have one.
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$DIR/.zshrc" ]; then
    echo "error: no .zshrc next to this script" >&2
    exit 1
fi

cp "$DIR/.zshrc" "$HOME/.zshrc"
echo "installed $DIR/.zshrc -> $HOME/.zshrc"
