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

### **6. (Optional) Run on shell startup** — add this line to `~/.bashrc` and/or `~/.zshrc`:

```sh
fastfetch
```

### Designs

| 01 — Minimal (default) | 02 — Tree / Box |
|---|---|
| [![01-minimal](01-minimal/screenshot.png)](01-minimal/screenshot.png) | [![02-tree](02-tree/screenshot.png)](02-tree/screenshot.png) |
| `fastfetch -c 01-minimal/config.jsonc` | `fastfetch -c 02-tree/config.jsonc` |
