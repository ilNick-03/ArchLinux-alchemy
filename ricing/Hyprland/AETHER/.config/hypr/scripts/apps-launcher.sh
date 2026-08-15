#!/usr/bin/bash
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info: https://www.gnu.org/licenses/gpl-3.0.html


# Launch Wofi in drun mode sorted strictly A-Z, ignoring past usage frequency
exec wofi --show drun \
    --sort-order=alphabetical \
    --cache-file=/dev/null \
    --conf "$HOME/.config/wofi/config" \
    --style "$HOME/.config/wofi/style.css" \
    --insensitive