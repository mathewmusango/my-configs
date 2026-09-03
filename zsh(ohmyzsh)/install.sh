#!/usr/bin/env sh
# Install the repo's .zshrc and .p10k.zsh as the live configs (no symlinks).
# Overwrites ~/.zshrc and ~/.p10k.zsh — back them up first if you have one.
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$DIR/.zshrc" ]; then
    echo "error: no .zshrc next to this script" >&2
    exit 1
fi

cp "$DIR/.zshrc" "$HOME/.zshrc"
echo "installed $DIR/.zshrc -> $HOME/.zshrc"

if [ -f "$DIR/.p10k.zsh" ]; then
    cp "$DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    echo "installed $DIR/.p10k.zsh -> $HOME/.p10k.zsh"
fi
