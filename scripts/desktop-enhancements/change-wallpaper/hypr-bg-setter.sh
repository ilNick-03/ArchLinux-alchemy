#!/usr/bin/env zsh
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


# --- INPUT VALIDATION & PIPELINE INIT ---

# Capture positional parameter ($1) or read from standard input (if piped)
local TARGET_IMAGE="$1"
if [[ -z "$TARGET_IMAGE" && ! -t 0 ]]; then
    read -r TARGET_IMAGE
fi

# Validate payload existence and integrity
if [[ -z "$TARGET_IMAGE" || ! -f "$TARGET_IMAGE" ]]; then
    echo "Fatal Exception: Invalid or missing deployment target image." >&2
    echo "Usage: $0 /path/to/image.jpg  OR  selector.zsh | $0" >&2
    exit 1
fi

# Resolve absolute path natively via ZSH parameter expansion modifier (:A) 
local TARGET_IMAGE_ABS="${TARGET_IMAGE:A}"


# --- ENVIRONMENT SETUP & DAEMON MANAGEMENT ---

local USER_ID=$(id -u) 
export XDG_RUNTIME_DIR="/run/user/$USER_ID"
export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1rt $XDG_RUNTIME_DIR/hypr/ 2>/dev/null | grep -v ".sock" | tail -n 1)

# Graceful termination if the compositor pipeline is offline
[[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]] && exit 0

# Check daemon state: if hyprpaper is dead, spawn a new background instance 
if ! pgrep -x "hyprpaper" > /dev/null; then
    hyprpaper &
    # Enforce a mandatory delay to allow the daemon to allocate memory and expose its IPC socket 
    sleep 1
fi


# --- EPHEMERAL ASSET STAGING ---

# Generate an atomic, nanosecond-precise session identifier to prevent cache collisions 
local SESSION_ID=$(date +%N)
local TMP_WP="/tmp/wp_${SESSION_ID}.img"

# Inject a symbolic link into the temporary file system 
ln -sf "$TARGET_IMAGE_ABS" "$TMP_WP"


# --- RENDER ENGINE DISPATCH ---

# Dynamically map all active viewports (monitors) attached to the compositor 
local MONITORS=(${(f)"$(hyprctl monitors | grep 'Monitor' | awk '{print $2}' | sed 's/://g')"})

# 1. Preload the ephemeral asset into VRAM (Synchronous operation) 
hyprctl hyprpaper preload "$TMP_WP"

# 2. Map the preloaded texture array to all detected displays 
for m in $MONITORS; do 
    hyprctl hyprpaper wallpaper "$m,$TMP_WP"
done


# --- GARBAGE COLLECTION & MEMORY MANAGEMENT --- 

# Suspend execution thread to guarantee VRAM buffer swap completion 
sleep 2

# Purge unmapped textures from the GPU memory allocator to preserve hardware resources 
hyprctl hyprpaper unload unused

# Destroy legacy symlink nodes in the temporary directory, retaining only the active payload 
find /tmp -name "wp_*.img" ! -name "wp_${SESSION_ID}.img" -delete 2>/dev/null

echo "Display matrix successfully updated. Active node: $(basename "$TARGET_IMAGE_ABS")"
