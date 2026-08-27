# my-configs

My configs repo. Modules live in a dedicated folder (e.g. `fastfetch/`) or `.config/<app>/`; each module has a `README.md` recording setup steps.

## Modules

| Module | Dir | Status | Notes |
|---|---|---|---|
| [`fastfetch-cli/fastfetch`](https://github.com/fastfetch-cli/fastfetch) | [`fastfetch/`](fastfetch/README.md) | ✅ live | designs 01-minimal & 02-tree; activate via `fastfetch/replace.sh <design>` (copies config to `~/.config/fastfetch/config.jsonc`, no symlinks) |

## How to add a module

1. Config goes in a dedicated folder (`<app>/` or `.config/<app>/`) in this repo.
2. Install by copying the config to the app's real location (e.g. `cp fastfetch/02-tree/config.jsonc ~/.config/fastfetch/config.jsonc`) — or symlink if the app benefits from live updates.
3. Write `<app>/README.md` with the steps (see the fastfetch one as a template).
4. Verify it works on this machine.
5. Append a row to the table above.

## License

MIT — see [LICENSE](LICENSE).
