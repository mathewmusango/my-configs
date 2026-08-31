# yay (AUR helper)

[`Yay`](https://github.com/Jguer/yay) — "Yet another Yogurt": an AUR helper for Arch. Needed to install AUR packages like `ttf-meslo-nerd-font-powerlevel10k`.

> **Why yay?** `pacman` covers the official repos only; AUR packages (community PKGBUILDs) need `makepkg`. yay wraps pacman — same commands, plus AUR search and one-step builds: it clones the PKGBUILD to `~/.cache/yay/`, runs `makepkg` (sources + checksums), and installs with `pacman -U`. Arch/Arch-based only (EndeavourOS, Manjaro, CachyOS).

## Install

**1. Install prerequisites** (base-devel + git)

```sh
sudo pacman -S --needed base-devel git
```

**2. Clone and build yay**

```sh
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

**3. Verify**

```sh
yay --version
```

## Usage

```sh
yay -S <package>    # install from the AUR or repos
yay -Syu            # update everything (repos + AUR)
```

AUR page: https://aur.archlinux.org/packages/yay
