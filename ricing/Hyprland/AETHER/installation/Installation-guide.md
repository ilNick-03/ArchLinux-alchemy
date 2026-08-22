## 💾 Installation & Deployment

Before modifying your desktop infrastructure, remember the core Roman architectural maxim: *ensure the foundation is secure before erecting the framework*.
Deploying *A.E.T.H.E.R.* involves linking configuration nodes.

### 0. The Defensive Sentinel: Mandatory Backup Strategy

> [!TIP]
> Do not proceed without archiving your current user-space environments. Run the following command inside your terminal to generate an atomic, timestamped snapshot of your entire `.config` directory:
> ```bash
> # Generate a compressed tarball backup with exact calendar tracking
> tar -czf "$HOME/config-backup-$(date +%Y%m%d-%H%M%S).tar.gz" -C "$HOME" .config
> 
> ```
> 
> 
> *If anything breaks during deployment, you can restore your pristine state instantly via*:
> ```bash
> tar -xzf ~/config-backup-*.tar.gz -C ~
> 
> ```
> 
> 

### 1. Cloning the Alchemical Repository

Acquire the source blueprint from the official distribution socket using `git`. This fetches the full alchemy stack repository:

```bash
cd $HOME
git clone https://github.com/ilNick-03/ArchLinux-alchemy.git
cd ArchLinux-alchemy/ricing/Hyprland/AETHER

```

### 2. Deploying Configuration Files


#### **Step I: Clean pre-existing configuration directories**

Remove pre-existing targets to prevent link nesting or file collision errors:
```bash
rm -rf "$HOME/.config/dunst" "$HOME/.config/fastfetch" "$HOME/.config/hypr" "$HOME/.config/swayidle" "$HOME/.config/waybar" "$HOME/.config/wlogout" "$HOME/.config/wofi"

```

#### **Step II: Deploy main configurations**

Execute your favourite one:
- **Option A (Symlinks):**
Best for active development and easy upstream synchronization.
Link live nodes directly into `$HOME/.config/`.
```bash
ln -s "$(pwd)/.config/dunst" "$HOME/.config/"
ln -s "$(pwd)/.config/fastfetch" "$HOME/.config/"
ln -s "$(pwd)/.config/hypr" "$HOME/.config/"
ln -s "$(pwd)/.config/swayidle" "$HOME/.config/"
ln -s "$(pwd)/.config/waybar" "$HOME/.config/"
ln -s "$(pwd)/.config/wlogout" "$HOME/.config/"
ln -s "$(pwd)/.config/wofi" "$HOME/.config/"
```

- **Option B (Physical Copies):**
Best for standalone, immutable setups.
Copy files directly, cutting all ties with the local repository.
```bash
cp -r ".config/dunst" "$HOME/.config/"
cp -r ".config/fastfetch" "$HOME/.config/"
cp -r ".config/hypr" "$HOME/.config/"
cp -r ".config/swayidle" "$HOME/.config/"
cp -r ".config/waybar" "$HOME/.config/"
cp -r ".config/wlogout" "$HOME/.config/"
cp -r ".config/wofi" "$HOME/.config/"
```




#### **Step III: Integrate the custom GTK stylesheet**

Create the target directory and link or copy the UI layout file matching your deployment vector:
```bash
mkdir -p "$HOME/.config/gtk-3.0"

```


- **Option A (Symlink):**
```bash
ln -s "$(pwd)/.config/gtk-3.0/aether-win-menu.css" "$HOME/.config/gtk-3.0/"

```

- **Option B (Physical Copy):**
```bash
cp ".config/gtk-3.0/aether-win-menu.css" "$HOME/.config/gtk-3.0/aether-win-menu.css"

```




#### **Step IV: Import stylesheet into *GTK-3-* settings**
Open your primary `gtk.css` file with your preferred text editor:
```bash
$EDITOR "$HOME/.config/gtk-3.0/gtk.css"

```


Add the following import line at the top of the file (or alongside existing `@import` directives):
```css
@import url('aether-win-menu.css');

```



### 3. Establish Core Automation Script Symlinks

A.E.T.H.E.R. routes its dynamic canvas engines through standard local executable paths.
To preserve absolute directory modularity while keeping your master scripts centralized under your primary `~/scripts` repository, you must deploy atomic symbolic links inside the *Hyprland- configuration structure.

Execute the following commands inside your terminal wrapper to map the script nodes seamlessly without moving your original files:

```bash
cd "$HOME/ArchLinux-alchemy"

# 1. Inject forced symbolic links pointing to your master script layers
ln -sf "$HOME/ArchLinux-alchemy/scripts/desktop-enhancements/random-wallpaper-selector.sh" "$HOME/.config/hypr/scripts/"
ln -sf "$HOME/ArchLinux-alchemy/scripts/desktop-enhancements/change-wallpaper/hypr-bg-setter.sh" "$HOME/.config/hypr/scripts/"
ln -sf "$HOME/ArchLinux-alchemy/scripts/desktop-enhancements/change-wallpaper/sway-bg-setter.sh" "$HOME/.config/hypr/scripts/"

# 2. Ensure internal Hyprland automation scripts are present and executable
# (apps-launcher.sh, clipboard-selector.sh, hypr-binds-map.sh)
chmod +x "$HOME/.config/hypr/scripts/"*.sh

```

> [!NOTE]
> The `-sf` (*Symbolic, Force*) architecture guarantees that any pre-existing or broken pointer nodes inside the *Hyprland- directory will be safely overwritten and realigned to your master files, ensuring an idempotent and non-destructive deployment.

### 4. Optional: ["*Futuristic Audio Session*" shell music player](https://www.google.com/search?q=../../../dotfiles/shell/custom/.futuristic-audio-session)

If you plan to utilize the ***Futuristic Audio Session**- music listening environment via `SUPER + SHIFT + A`, follow these two steps:

#### A. Source the Shell Environment

Open your local shell configuration file (`~/.zshrc` or `~/.bashrc`) and append the following alchemical directive at the very bottom:

```bash
# Source A.E.T.H.E.R. 'Futuristic Audio Session' functions
[[ -f "$HOME/ArchLinux-alchemy/dotfiles/shell/custom/.futuristic-audio-session" ]] && source "$HOME/ArchLinux-alchemy/dotfiles/shell/custom/.futuristic-audio-session"

```

> [!TIP]
> This defensive guard condition ensures that your shell initializes flawlessly and without throwing errors even if the cloned repository path is temporarily missing or relocated during system cleanups.

#### B. Uncomment the Keybindings in [keybindings.lua](https://www.google.com/search?q=../../../ricing/Hyprland/AETHER/.config/hypr/modules/keybindings.lua)

Open `./.config/hypr/modules/keybindings.lua` and uncomment the following lines to make this feature actually working by typing these keyboard shortcuts:

```lua
-- Futuristic Audio Session (custom 'terminal music player' setup)
-- Only for TRVE music enthusiasts!
map.bind(mainMod .. " + SHIFT + A",        hl.dsp.exec_cmd("zsh -ic 'audio-session'"),           { description = "Launch the 'futuristic audio session'" })
map.bind(mainMod .. " + SHIFT + ALT + A",  hl.dsp.exec_cmd("zsh -ic 'close-audio-session'"),     { description = "Terminate the 'futuristic audio session'" })

```

---

## 🚀 Post-Installation & Manual Adjustments

*A.E.T.H.E.R.* is configured out of the box, but requires minimal path alignment and asset positioning to conform to your specific hardware layout.

### 1. Wallpaper Gallery Setup & Default Background Initialization

*A.E.T.H.E.R.* manages wallpaper rotation through native daemons (`hyprpaper` or `swaybg`) controlled via [hypr-bg-setter.sh](https://www.google.com/search?q=../../../scripts/desktop-enhancements/change-wallpaper/hypr-bg-setter.sh) / [sway-bg-setter.sh](https://www.google.com/search?q=../../../scripts/desktop-enhancements/change-wallpaper/sway-bg-setter.sh) and [random-wallpaper-selector.sh](https://www.google.com/search?q=../../../scripts/desktop-enhancements/random-wallpaper-selector.sh).

1. Read the [dedicated wallpaper guide](https://www.google.com/search?q=./Wallpapers.md) to obtain the recommended high-resolution artwork collection.
2. Place your downloaded wallpapers into your preferred picture directory (e.g., `~/Pictures/Wallpapers/`).
3. Set your default startup wallpaper by placing an image named `splash.jpg` inside `$HOME/.config/hypr/` **OR*- update the initial wallpaper path in `./.config/hypr/modules/vars.lua`:

```lua
-- Initial wallpaper rendered upon compositor startup
local initial_WP = os.getenv("HOME") .. "/.config/hypr/splash.jpg"

```

### 2. Align Environment Directories in [vars.lua](https://www.google.com/search?q=../../../ricing/Hyprland/AETHER/.config/hypr/modules/vars.lua)

Open the global variables module located at `./.config/hypr/modules/vars.lua`.
Confirm or update the script and wallpaper root directories to reflect your system layout:

```lua
-- Set your relevant root directories
_G.home_dir     =  os.getenv("HOME")
_G.scripts_dir  =  os.getenv("HOME") .. "/scripts"  -- Points directly to your custom executable layers

```

### 3. Tailor Your Graphic Profile (Dual-GPU Configuration)

*A.E.T.H.E.R.* provides a split variable map to toggle hardware rendering profiles.
If you are running an NVIDIA or Intel dedicated card (`dGPU`), open `./.config/hypr/modules/vars.lua`, un-comment the relative driver strategy:

```lua
-- === Rendering with dGPU NVIDIA - performance ===
hl.env("LIBVA_DRIVER_NAME",         "nvidia")
hl.env("GBM_BACKEND",               "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

```

### 4. Apply Unified Styling Across UI Engines

To prevent mixed fonts and inconsistent white window frames from breaking the Synthwave theme immersion:

1. Confirm that `qt6ct` and/or `Kvantum` are configured as your primary theme engines.
2. If needed, uncomment `hl.env("QT_STYLE_OVERRIDE" , "kvantum")` in [vars.lua](https://www.google.com/search?q=../../../ricing/Hyprland/AETHER/.config/hypr/modules/vars.lua).
The Lua configuration enforces `kvantum` theme across all *QT*-based *GUI- applications.
3. Verify that your `$HOME/.config/gtk-3.0/gtk.css` file properly includes `@import url('aether-win-menu.css');` as configured during deployment.
