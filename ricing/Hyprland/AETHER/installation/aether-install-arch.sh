#!/bin/bash
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


# ==================================================================================
# A.E.T.H.E.R. Automated Deployment Script
# Designed for: Arch Linux + Hyprland
#
# -- WARNING --
#  This code is not tested. The auto-install feature is experimental.
#  Execute it at your own risk. Otherwise, follow Installation.md for manual setup
# ==================================================================================


set -e    # Exit immediately if a command exits with a non-zero status

# --- AESTHETICS & LOGGING ---
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${CYAN}[*]${NC} $1"; }
log_success() { echo -e "${GREEN}[+]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[!]${NC} $1"; }
log_err() { echo -e "${RED}[X]${NC} $1"; }

echo -e "${CYAN}"
cat << "EOF"
    _    _____ _____ _   _ _____ ____
   / \  | ____|_   _| | | | ____|  _ \
  / _ \ |  _|   | | | |_| |  _| | |_) |
 / ___ \| |___  | | |  _  | |___|  _ <
/_/   \_\_____| |_| |_| |_|_____|_| \_\

            __           _          __       ____
 ___ ___ __/ /____  ____(_)__  ___ / /____ _/ / /
/ _ `/ // / __/ _ \/___/ / _ \(_-</ __/ _ `/ / /
\_,_/\_,_/\__/\___/   /_/_//_/___/\__/\_,_/_/_/

EOF
echo -e "${NC}Automated Deployment Protocol Initiated...\n"

# --- 0. DEPENDENCY RESOLUTION ---
log_info "Phase 0: Verifying Package Manager..."
if ! command -v yay &> /dev/null; then
    log_warn "'yay' not found. Deploying yay from AUR..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd - > /dev/null
    rm -rf /tmp/yay
    log_success "'yay' deployed successfully."
fi

log_info "Resolving system dependencies (Essential & Optional Stack)..."
# Extracted directly from README.md and vars.lua requirements
DEPS=(
    alacritty blueman brightnessctl dunst gtk3 gtk4 swayidle hyprland hyprpaper 
    hyprshutdown pipewire wireplumber qt6ct tmux waybar wlogout wofi xfce-polkit zsh
    btop cliphist wl-clipboard fastfetch grim slurp imagemagick kate 
    librewolf obs-studio obs-cmd playerctl thunar yazi
)
# We use --needed to skip already installed packages and avoid unnecessary recompilations
yay -Sy --needed --noconfirm "${DEPS[@]}"
log_success "All dependencies satisfied."


# --- 1. MANDATORY BACKUP STRATEGY ---
log_info "Phase 1: The Defensive Sentinel (Backup)..."
BACKUP_FILE="$HOME/config-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
if [ -d "$HOME/.config" ]; then
    tar -czf "$BACKUP_FILE" -C "$HOME" .config
    log_success "Atomic snapshot generated at: $BACKUP_FILE"
else
    log_warn "$HOME/.config does not exist. Skipping backup."
fi


# --- 2. CLONING THE ALCHEMICAL REPOSITORY ---
log_info "Phase 2: Acquiring Source Blueprint..."
REPO_DIR="$HOME/ArchLinux-alchemy"
AETHER_DIR="$REPO_DIR/ricing/Hyprland/AETHER"

if [ -d "$REPO_DIR" ]; then
    log_warn "Repository already exists at $REPO_DIR. Pulling latest changes..."
    cd "$REPO_DIR" && git pull
else
    git clone https://github.com/ilNick-03/ArchLinux-alchemy.git "$REPO_DIR"
    log_success "Repository cloned."
fi


# --- 3. DEPLOYING CONFIGURATION FILES ---
log_info "Phase 3: Deploying Core Configuration Nodes..."

# Step I: Clean pre-existing targets (including fastfetch as seen in immagine_2.png)
log_info "Cleaning pre-existing configuration directories to prevent collisions..."
rm -rf "$HOME/.config/dunst" "$HOME/.config/fastfetch" "$HOME/.config/hypr" "$HOME/.config/swayidle" \
       "$HOME/.config/waybar" "$HOME/.config/wlogout" "$HOME/.config/wofi"

# Step II: Deploy via Symlinks (Option A - Best for development)
log_info "Grafting symbolic links..."
mkdir -p "$HOME/.config"
# Note: Using -sfn to force overwrite and prevent symlink nesting issues
ln -sfn "$AETHER_DIR/.config/dunst" "$HOME/.config/dunst"
ln -sfn "$AETHER_DIR/.config/fastfetch" "$HOME/.config/fastfetch"
ln -sfn "$AETHER_DIR/.config/hypr" "$HOME/.config/hypr"
ln -sfn "$AETHER_DIR/.config/swayidle" "$HOME/.config/swayidle"
ln -sfn "$AETHER_DIR/.config/waybar" "$HOME/.config/waybar"
ln -sfn "$AETHER_DIR/.config/wlogout" "$HOME/.config/wlogout"
ln -sfn "$AETHER_DIR/.config/wofi" "$HOME/.config/wofi"

# Step III & IV: GTK Stylesheet Integration
log_info "Integrating custom GTK-3 stylesheet..."
mkdir -p "$HOME/.config/gtk-3.0"
ln -sfn "$AETHER_DIR/.config/gtk-3.0/aether-win-menu.css" "$HOME/.config/gtk-3.0/aether-win-menu.css"

GTK_CSS="$HOME/.config/gtk-3.0/gtk.css"
touch "$GTK_CSS" # Ensure the file exists before grepping
if ! grep -q "aether-win-menu.css" "$GTK_CSS"; then
    # Prepend the import to the top of the file
    echo -e "@import url('aether-win-menu.css');\n$(cat "$GTK_CSS")" > "$GTK_CSS"
    log_success "GTK Stylesheet injected into gtk.css."
else
    log_warn "GTK Stylesheet import already exists. Skipping."
fi


# --- 4. CORE AUTOMATION SCRIPTS ---
log_info "Phase 4: Establishing Script Automation Pointers..."
mkdir -p "$HOME/.config/hypr/scripts"

# Force symlinks with explicit target names to prevent nesting bugs
ln -sf "$REPO_DIR/scripts/desktop-enhancements/random-wallpaper-selector.sh" "$HOME/.config/hypr/scripts/random-wallpaper-selector.sh"
ln -sf "$REPO_DIR/scripts/desktop-enhancements/change-wallpaper/hypr-bg-setter.sh" "$HOME/.config/hypr/scripts/hypr-bg-setter.sh"
ln -sf "$REPO_DIR/scripts/desktop-enhancements/change-wallpaper/sway-bg-setter.sh" "$HOME/.config/hypr/scripts/sway-bg-setter.sh"

chmod +x "$HOME/.config/hypr/scripts/"*.sh
log_success "Script nodes synced and execution permissions granted."


# --- 5. OPTIONAL: FUTURISTIC AUDIO SESSION ---
echo -e "\n${CYAN}[?]${NC} Do you want to enable the (optional) 'Futuristic Audio Session' keybindings and shell setup? (y/n)"
read -r -p " > " enable_audio

if [[ "$enable_audio" =~ ^[Yy]$ ]]; then
    log_info "Phase 5: Sourcing Audio Session environment..."
    
    # Inject into .zshrc if exists
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "\.futuristic-audio-session" "$HOME/.zshrc"; then
            echo -e "\n# Source A.E.T.H.E.R. 'Futuristic Audio Session' functions" >> "$HOME/.zshrc"
            echo "[[ -f \"\$HOME/ArchLinux-alchemy/dotfiles/shell/custom/.futuristic-audio-session\" ]] && source \"\$HOME/ArchLinux-alchemy/dotfiles/shell/custom/.futuristic-audio-session\"" >> "$HOME/.zshrc"
            log_success "Injected into .zshrc"
        fi
    fi

    # Inject into .bashrc if exists
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "\.futuristic-audio-session" "$HOME/.bashrc"; then
            echo -e "\n# Source A.E.T.H.E.R. 'Futuristic Audio Session' functions" >> "$HOME/.bashrc"
            echo "[[ -f \"\$HOME/ArchLinux-alchemy/dotfiles/shell/custom/.futuristic-audio-session\" ]] && source \"\$HOME/ArchLinux-alchemy/dotfiles/shell/custom/.futuristic-audio-session\"" >> "$HOME/.bashrc"
            log_success "Injected into .bashrc"
        fi
    fi

    # Uncomment keybindings in lua using regex to find and strip the leading '-- ' (handling possible spaces)
    KEYBIND_FILE="$AETHER_DIR/.config/hypr/modules/keybindings.lua"
    if [ -f "$KEYBIND_FILE" ]; then
        sed -i -E 's/^--[[:space:]]*(map\.bind.*audio-session.*)/\1/g' "$KEYBIND_FILE"
        log_success "Keybindings successfully uncommented in keybindings.lua"
    fi
else
    log_info "Skipping Futuristic Audio Session setup."
fi

# --- COMPLETION ---
echo -e "\n${GREEN}======================================================================${NC}"
echo -e "${GREEN}  A.E.T.H.E.R. Deployment Completed Successfully!${NC}"
echo -e "${GREEN}======================================================================${NC}"
cat << "EOF"
Post-Installation Reminders:
 1. Place your wallpapers in ~/Pictures/Wallpapers/
 2. Add 'splash.jpg' in ~/.config/hypr/ for the startup background
 3. Ensure 'qt6ct' or 'Kvantum' are set as your primary QT engines
 4. Restart your compositor (or system) for the alchemy to take full effect.

"Firmitas, Utilitas, Venustas."
EOF
