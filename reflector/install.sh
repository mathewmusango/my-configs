#!/usr/bin/env sh
# Install the repo's reflector configs (no symlinks).
# Root required: copies into /etc and (re)enables the daily timer.
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$(id -u)" -ne 0 ]; then
    echo "error: run as root: sudo ./reflector/install.sh" >&2
    exit 1
fi

if [ ! -f "$DIR/override.conf" ] || [ ! -f "$DIR/reflector.conf" ]; then
    echo "error: override.conf and reflector.conf must sit next to this script" >&2
    exit 1
fi

mkdir -p /etc/systemd/system/reflector.timer.d
cp "$DIR/override.conf" /etc/systemd/system/reflector.timer.d/override.conf
echo "installed $DIR/override.conf -> /etc/systemd/system/reflector.timer.d/override.conf"

mkdir -p /etc/xdg/reflector
cp "$DIR/reflector.conf" /etc/xdg/reflector/reflector.conf
echo "installed $DIR/reflector.conf -> /etc/xdg/reflector/reflector.conf"

systemctl daemon-reload
systemctl enable --now reflector.timer
echo "enabled + started reflector.timer (daily mirror refresh)"
