#!/bin/zsh
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


# --- INPUT VALIDATION & PIPELINE INIT ---

# Capture the positional parameter (target asset)
TARGET_IMAGE="$1"

# Validate payload existence and integrity
if [[ -z "$TARGET_IMAGE" || ! -f "$TARGET_IMAGE" ]]; then
    echo "Fatal Exception: Invalid or missing deployment target."
    echo "Syntax:    $0 /path/to/image.jpg"
    exit 1
fi

# Resolve the absolute path natively via ZSH parameter expansion modifier (:A)
# This prevents broken symbolic links if the script is called from disparate directories.
TARGET_IMAGE_ABS="${TARGET_IMAGE:A}"


# --- EPHEMERAL ASSET STAGING ---

# Generate an atomic, nanosecond-precise session identifier to prevent cache collisions
SESSION_ID=$(date +%N)
TMP_WP="/tmp/wp_${SESSION_ID}.img"

# Inject a symbolic link into the temporary file system.
# This strictly bypasses whitespace and special-character parsing errors within the IPC daemon.
ln -sf "$TARGET_IMAGE_ABS" "$TMP_WP"


# --- IPC SOCKET VALIDATION & DAEMON SPAWNING ---

USER_ID=$(id -u)
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


# --- RENDER ENGINE DISPATCH ---

# Dynamically map all active viewports (monitors) attached to the compositor
MONITORS=(${(f)"$(hyprctl monitors | grep 'Monitor' | awk '{print $2}' | sed 's/://g')"})

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


echo "Display matrix successfully updated. Active node:  $(basename "$TARGET_IMAGE_ABS")"
