#!/usr/bin/env zsh
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


# --- CONFIGURATION ---
# Default directory if none are provided.
local DEFAULT_DIR="$HOME/Immagini/Wallpapers"

# Populate the array of target directories
local dirs=()
if [[ $# -eq 0 ]]; then
    dirs=("$DEFAULT_DIR")
else
    dirs=("$@")
fi


# --- SELECTION LOGIC ---
local random_image=""

# Searching for images using case-insensitive regex for common web/desktop formats
if command -v fd &> /dev/null; then
    # Use 'fd' (faster, Rust-based) if available
    random_image=$(fd -e jpg -e jpeg -e png -e webp -e avif -i . "${dirs[@]}" | shuf -n 1)
else
    # Otherwise fallback to 'find', for universal compatibility
    random_image=$(find "${dirs[@]}" -type f -iregex '.*\.\(jpg\|jpeg\|png\|webp\|avif\)' | shuf -n 1)
fi

# Verifying that an image was found
if [[ -z "$random_image" ]]; then
    # Print error to stderr to avoid polluting the output variable in the setter script
    echo "Error: No valid images (.jpg, .png, .webp, .avif) found in the specified directories." >&2
    exit 1
fi


# Print ONLY the absolute path to standard output
echo "$random_image"
