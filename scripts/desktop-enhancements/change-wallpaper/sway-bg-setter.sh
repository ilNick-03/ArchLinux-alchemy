#!/usr/bin/env zsh
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


# --- CONFIGURATION ---
local FALLBACK_RES="1920x1080"


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


# --- UNIVERSAL DYNAMIC RESOLUTION DETECTION ---

local TARGET_RES="$FALLBACK_RES"

# 1. Try Hyprland native IPC
if command -v hyprctl &> /dev/null && [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    TARGET_RES=$(hyprctl monitors 2>/dev/null | grep -m 1 -oP '\d+x\d+')
# 2. Try Sway native IPC
elif command -v swaymsg &> /dev/null && [[ -n "$SWAYSOCK" ]]; then
    TARGET_RES=$(swaymsg -pt get_outputs 2>/dev/null | grep -m 1 -oP '\d+x\d+')
# 3. Try Universal Wlroots tool (for River, Wayfire, Labwc, etc.)
elif command -v wlr-randr &> /dev/null; then
    TARGET_RES=$(wlr-randr 2>/dev/null | grep -m 1 -oP '\d+x\d+')
fi

# Sanity check: if detection returned an empty string or bad format, revert to fallback
if [[ ! "$TARGET_RES" =~ ^[0-9]+x[0-9]+$ ]]; then
    TARGET_RES="$FALLBACK_RES"
fi


# --- IMAGE ENHANCEMENT PIPELINE (ImageMagick) ---

# Ensure ImageMagick is installed before proceeding
if ! command -v magick &> /dev/null; then
    echo "Error: 'imagemagick' is not installed. High-quality pipeline requires it." >&2
    exit 1
fi

# Generate an atomic session ID for the ephemeral optimized image
local SESSION_ID=$(date +%N)
local TMP_WP="/tmp/hq_wp_${SESSION_ID}.png"

# ImageMagick processing pipeline (dynamically matching the current monitor's geometry)
magick "$TARGET_IMAGE_ABS" \
    -filter Lanczos \
    -resize "${TARGET_RES}^" \
    -gravity center \
    -extent "$TARGET_RES" \
    -unsharp 0x0.5+0.5+0.008 \
    -depth 8 \
    "$TMP_WP"


# --- SWAYBG IMPLEMENTATION (WALLPAPER CHANGING) ---

if ! command -v swaybg &> /dev/null; then 
    echo "Error: 'swaybg' is not installed." >&2 
    exit 1 
fi 

# Kill the existing swaybg process
pkill swaybg 

# Launch swaybg passing the newly generated High-Quality temporary asset
swaybg -i "$TMP_WP" -m fill & 

disown 


# --- GARBAGE COLLECTION & MEMORY MANAGEMENT --- 

# Wait briefly to ensure swaybg has successfully loaded the image into memory
sleep 2

# Destroy legacy temporary files to avoid filling up the /tmp directory
find /tmp -name "hq_wp_*.png" ! -name "hq_wp_${SESSION_ID}.png" -delete 2>/dev/null

echo "Display matrix successfully updated. Active node: $(basename "$TARGET_IMAGE_ABS") (HQ Processed: $TARGET_RES)"
