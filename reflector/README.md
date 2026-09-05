# Reflector

**Auto-updates the [`pacman`](https://archlinux.org/pacman/) mirrorlist daily** — rate-sorted HTTPS mirrors, so [`yay`](../yay/README.md) / `pacman -Syu` stays fast.

## Files

- `override.conf` — timer override: clears the stock weekly schedule, runs reflector **daily**
- `reflector.conf` — mirror filters: save to `/etc/pacman.d/mirrorlist`, HTTPS only, 5 latest, sort by rate
- `install.sh` — copies both into `/etc` and enables the timer (root)

## Setup

**1. Install reflector**

```sh
sudo pacman -S reflector
```

**2. Install configs + enable the daily timer**

```sh
sudo ./reflector/install.sh
```

**3. Verify**

```sh
systemctl list-timers reflector.timer
```
