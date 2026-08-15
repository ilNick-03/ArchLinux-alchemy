#!/usr/bin/bash
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info: https://www.gnu.org/licenses/gpl-3.0.html


# 1. Fetch clipboard history, truncate preview to ~60 characters for compactness, and display in Wofi
selected=$(cliphist list | head -n 30 | awk -F'\t' '{
    # If the preview text (field 2) exceeds 60 characters, truncate it and append ellipsis
    if (length($2) > 62) 
        $2 = substr($2, 1, 62) "..."
    
    # Print the ID (field 1) and the shortened preview, separated by tab
    print $1 "\t" $2
}' | wofi --dmenu \
    --prompt "Clipboard History" \
    --width 720 \
    --conf "$HOME/.config/wofi/config" \
    --style "$HOME/.config/wofi/style.css" \
    --insensitive)


# 2. Exit silently if selection was cancelled (e.g. ESC pressed)
[ -z "$selected" ] && exit 0


# 3. Decode the selected item by ID to fetch the full untruncated content, then copy to clipboard
echo "$selected" | cliphist decode | wl-copy


# 4. Notify user
notify-send -u low "Clipboard" "Item successfully copied to clipboard." -i edit-copy