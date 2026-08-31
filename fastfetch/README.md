# Fastfetch Designs

**Config designs for [`Fastfetch`](https://github.com/fastfetch-cli/fastfetch)**.

### **1.Clone**

```sh
git clone https://github.com/mathewmusango/my-configs.git
cd my-configs/fastfetch
```

### **2. Install fastfetch** (if not present)

```sh
# Arch
sudo pacman -S fastfetch
# Debian/Ubuntu
sudo apt install fastfetch
# Fedora
sudo dnf install fastfetch
```

> **Note — Nerd Font:** the tree design uses Nerd Font icons — install MesloLGS NF and select it in your terminal, or icons render as `□`:
> ```sh
> # Arch
> sudo pacman -S ttf-meslo-nerd-font-powerlevel10k
>
> # Debian/Ubuntu + Fedora (no package — download the TTFs)
> mkdir -p ~/.local/share/fonts
> curl -fLo ~/.local/share/fonts/MesloLGS\ NF\ Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
> curl -fLo ~/.local/share/fonts/MesloLGS\ NF\ Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
> curl -fLo ~/.local/share/fonts/MesloLGS\ NF\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
> curl -fLo ~/.local/share/fonts/MesloLGS\ NF\ Bold\ Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
> fc-cache -f ~/.local/share/fonts
> ```

### **3. Preview a design without installing**

```sh
fastfetch -c 01-minimal/config.jsonc
fastfetch -c 02-tree/config.jsonc
...
```

### **4. Activate a design** — Replace the current config

```sh
./replace.sh 01-minimal
or
./replace.sh 02-tree
...
```

### **5. Verify**

```sh
fastfetch
```

### **6. (Optional) Run on shell startup** — add this line to `~/.bashrc` and/or `~/.zshrc` (see the [`zsh` module](../zsh(ohmyzsh)/README.md)):


```sh
fastfetch
```

### Screenshots

| 01 — Minimal (default) | 02 — Tree / Box |
|---|---|
| [![01-minimal](01-minimal/screenshot.png)](01-minimal/screenshot.png) | [![02-tree](02-tree/screenshot.png)](02-tree/screenshot.png) |
| `fastfetch -c 01-minimal/config.jsonc` | `fastfetch -c 02-tree/config.jsonc` |

### More

```sh
fastfetch --gen-config      # generate the default config at ~/.config/fastfetch/config.jsonc
fastfetch --list-presets    # browse built-in presets
fastfetch --list-logos      # browse available distro logos
```
