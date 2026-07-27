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


# --- ENVIRONMENT SETUP ---

local USER_ID=$(id -u) 
export DISPLAY=:0 
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USER_ID/bus 

# Brief delay to avoid race conditions upon desktop resume 
sleep 2 


# --- KDE PLASMA DBUS INJECTION ---

# Inject wallpaper via evaluateScript API 
dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript "string:
var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; i++) {
    var d = allDesktops[i];
    d.wallpaperPlugin = 'org.kde.image';
    d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
    d.writeConfig('Image', 'file://${TARGET_IMAGE_ABS}');
}" 

echo "Wallpaper successfully changed to: $(basename "$TARGET_IMAGE_ABS")"
