# fastfetch designs

Config designs for [`fastfetch-cli/fastfetch`](https://github.com/fastfetch-cli/fastfetch) (v2.67.1), run on shell startup from `~/.bashrc` and `~/.zshrc`.

Each design is a folder with:

- `config.jsonc` — the design's config
- `screenshot.png` — render on this machine (generic user/host)

## Install (no symlinks)

Replace the live config with a design:

```sh
./replace.sh 02-tree        # copies design's config.jsonc to ~/.config/fastfetch/config.jsonc
```

Or manually:

```sh
cp 02-tree/config.jsonc ~/.config/fastfetch/config.jsonc
```

## Designs

### 01 — minimal

Clean two-column layout: auto distro logo, cyan key accent, colored title, curated module list grouped with blank lines.

![01-minimal](01-minimal/screenshot.png)

```sh
fastfetch -c 01-minimal/config.jsonc
```

### 02 — tree

Tree/box layout (old-days style): bordered sections (Hardware/Software/DE/Uptime) with Nerd Font icon keys, color-coded per section, color palette at the end. Current default.

![02-tree](02-tree/screenshot.png)

```sh
fastfetch -c 02-tree/config.jsonc
```

Add new designs as `NN-<name>/` folders (`config.jsonc` + `screenshot.png`) and list them above.
