#!/usr/bin/env zsh
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


# ===  A.E.T.H.E.R. BINDINGS EXPLORER  ===
# Professional TUI layout with continuous vertical and horizontal borders.
# Reads keybindings metadata directly from the Lua registry JSON cache.

    #  Box Drawing Characters logic:
    #   ┏━━━┳━━━┓  (Top with heavy corners and thick T-down)
    #   ┃   ┃   ┃  (Header & Data rows with thick vertical borders)
    #   ┣━━━╋━━━┫  (Header separator with thick cross junction)
    #   ┠╌╌╌╫╌╌╌┨  (Dashed row separator with hybrid junctions)
    #   ┗━━━┻━━━┛  (Bottom with heavy corners and thick T-up)


render_table() {
    # 'Deep Arctic' Color Palette
    local p=$'\e[1;35m' # Purple (Main Modifiers: SUPER / ALT)
    local c=$'\e[1;36m' # Cyan (Secondary: SHIFT / CTRL)
    local w=$'\e[0;37m' # White (Physical Keys / Descriptions)
    local b=$'\e[1;34m' # Arctic Blue (Borders and Separators)
    local r=$'\e[0m'    # Reset formatting

    local JSON_FILE="/tmp/hypr_binds.json"

    # 1. Top Border (Heavy Corners + Thick lines + Thick T-down junction)
    printf "${b}┏$(printf '━%.0s' {1..46})┳$(printf '━%.0s' {1..45})┓${r}\n"

    # 2. Header Row (Thick vertical borders '┃')
    printf "${b}┃ ${p}%-44s ${b}┃ ${p}%-43s ${b}┃${r}\n" "KEY COMBINATIONS" "DESCRIPTION"

    # 3. Header Separator (Thick horizontal + Thick cross junction)
    printf "${b}┣$(printf '━%.0s' {1..46})╋$(printf '━%.0s' {1..45})┫${r}\n"

    local first_row=true

    # 4. Data Extraction 
    jq -r '.[] | 
        # Modifiers columns extraction (Ordered: SUPER, SHIFT, ALT, CTRL)
        (.keys | if contains("SUPER") then "SUPER" else "" end) as $s |
        (.keys | if contains("SHIFT") then "SHIFT" else "" end) as $sh |
        (.keys | if contains("ALT")   then "ALT"   else "" end) as $al |
        (.keys | if contains("CTRL")  then "CTRL"  else "" end) as $ct |
        
        # Base key extraction (Expanded max length to 23 chars)
        (.keys | split("+") | last | gsub("^\\s+|\\s+$"; "") | ascii_upcase | if length > 23 then .[0:20] + "..." else . end) as $k |
        
        # Description sanitization
        (.description | if length > 43 then .[0:40] + "..." else . end) as $desc |
        
        "\($s)§\($sh)§\($al)§\($ct)§\($k)§\($desc)"
    ' "$JSON_FILE" | while IFS='§' read -r s sh al ct k desc; do
        
        # Inject Row Divider (skips the very first iteration)
        if [ "$first_row" = false ]; then
            # Dashed line separator ('╌') with hybrid junctions ('┠', '╂', '┨')
            printf "${b}┠$(printf '╌%.0s' {1..46})╂$(printf '╌%.0s' {1..45})┨${r}\n"
        fi
        first_row=false

        # 5. Data Rows 
        printf "${b}┃ ${p}%-5s ${c}%-5s ${p}%-3s ${c}%-4s ${w}%-23s ${b}┃ ${w}%-43s ${b}┃${r}\n" \
            "$s" "$sh" "$al" "$ct" "$k" "$desc"
    done

    # 6. Bottom Border (Heavy Corners + Thick lines + Thick T-up junction)
    printf "${b}┗$(printf '━%.0s' {1..46})┻$(printf '━%.0s' {1..45})┛${r}\n"

    # Footer Exit Prompt
    printf "\n${b} Press 'q' to close...${r}\n"
}


main() {
    local b=$'\e[1;34m'
    local p=$'\e[1;35m'
    local r=$'\e[0m'
    local JSON_FILE="/tmp/hypr_binds.json"

    # Check if the registry cache exists
    if [[ ! -f "$JSON_FILE" ]]; then
        printf "${b}┏$(printf '━%.0s' {1..94})┓${r}\n"
        printf "${b}┃ ${p}%-92s ${b}┃${r}\n" "ERROR: Keybindings cache not found. Please reload Hyprland."
        printf "${b}┗$(printf '━%.0s' {1..94})┛${r}\n"
        read -k 1 -s
        return 1
    fi

    # Pass table output through 'less -R' to lock view to line 1 and enable scrolling
    render_table | less -R
}


# Execute main function
main#!/bin/zsh
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


# --- A.E.T.H.E.R. BINDINGS EXPLORER (FULL BOX EDITION) ---
# Professional TUI layout with continuous vertical and horizontal borders.

# Deep Arctic Color Palette
local p=$'\e[1;35m' # Purple (Main Modifiers)
local c=$'\e[1;36m' # Cyan (Secondary Modifiers / Dispatchers)
local w=$'\e[0;37m' # White (Physical Keys / Descriptions)
local b=$'\e[1;34m' # Arctic Blue (Borders and Separators)
local r=$'\e[0m'    # Reset formatting

# Box Drawing Characters logic:
#   ╭───┬───╮  (Top)
#   │   │   │  (Middle)
#   ├───┼───┤  (Separator)
#   ╰───┴───╯  (Bottom)


# 1. Top Border (Rounded Corners)
# Total width: 40 (Keys) + 40 (Desc) + separators
printf "${b}╭$(printf '─%.0s' {1..40})┬$(printf '─%.0s' {1..42})╮${r}\n"

# 2. Header Row
printf "${b}│ ${p}%-38s ${b}│ ${p}%-40s ${b}│${r}\n" "KEY COMBINATIONS" "DESCRIPTION"

# 3. Middle Separator
printf "${b}├$(printf '─%.0s' {1..40})┼$(printf '─%.0s' {1..42})┤${r}\n"

# 4. Data Extraction
hyprctl binds -j | jq -r '.[] | 
    (if (.modmask >= 64) then "SUPER" else "" end) as $s |
    (if ((.modmask / 1 % 2) >= 1) then "SHIFT" else "" end) as $sh |
    (if ((.modmask / 8 % 2) >= 1) then "ALT"   else "" end) as $al |
    
    # Key Truncation
    (.key | ascii_upcase | if length > 18 then .[0:15] + "..." else . end) as $k |
    
    # Description Sanitization (Truncated to 40 for the new compact view)
    (if .description == "" or (.description | contains("__lua")) then "-" else .description end | if length > 40 then .[0:37] + "..." else . end) as $desc |
    
    "\($s)§\($sh)§\($al)§\($k)§\($desc)"
' | while IFS='§' read -r s sh al k desc; do
    
    # 5. Data Rows
    printf "${b}│ ${p}%-7s${c}%-8s${p}%-5s${w}%-18s ${b}│ ${w}%-40s ${b}│${r}\n" \
        "$s" "$sh" "$al" "$k" "$desc"
done

# 6. Bottom Border (Rounded Corners)
printf "${b}╰$(printf '─%.0s' {1..40})┴$(printf '─%.0s' {1..42})╯${r}\n"

# Footer Exit Prompt
printf "\n${b} Press any key to close...${r}"
read -k 1 -s
