#!/usr/bin/bash
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


# 1. Fetch Wi-Fi list with SIGNAL, BARS and SSID, sorted by signal strength descending
# Output format: BARS   SSID (e.g., ▂▄▆█   MyHomeWiFi)
wifi_list=$(nmcli -f SIGNAL,BARS,SSID -t device wifi list --rescan auto | \
    sort -t':' -k1,1nr | \
    awk -F':' '{
        bars = $2
        # Extract pure SSID even if it contains colons (stripping SIGNAL:BARS:)
        ssid = $0
        sub(/^[^:]*:[^:]*:/, "", ssid)
        
        # Filter hidden/empty SSIDs and deduplicate keeping the strongest signal
        if (ssid != "" && ssid != "--" && !seen[ssid]++) {
            print bars "   " ssid
        }
    }')

# Exit if no networks were found
if [ -z "$wifi_list" ]; then
    notify-send "Wi-Fi" "No Wi-Fi networks found." -i network-wireless
    exit 0
fi



# 2. Display network selection via Wofi (with case-insensitive search enabled)
chosen_network=$(echo "$wifi_list" | wofi --dmenu --prompt "Select Wi-Fi Network" --style ~/.config/wofi/style.css --insensitive)

# Force-kill Wofi and pause briefly so Hyprland unmaps the layer-shell window
pkill wofi 2>/dev/null
sleep 0.15

# Exit if selection was cancelled
[ -z "$chosen_network" ] && exit 0

# Extract pure SSID (stripping leading bars and spaces)
ssid=$(echo "$chosen_network" | sed -E 's/^[^ ]+[[:space:]]+//')



# 3. Attempt connection
notify-send "Wi-Fi" "Connecting to $ssid..." -i network-wireless

if nmcli device wifi connect "$ssid"; then
    notify-send "Wi-Fi" "Successfully connected to $ssid" -i network-wireless
else
    # If connection fails (unregistered/secured network), prompt for password via a fresh Wofi instance
    pass=$(wofi --dmenu --prompt "Enter Password for $ssid" --password --style ~/.config/wofi/style.css)
    pkill wofi 2>/dev/null

    if [ -n "$pass" ]; then
        notify-send "Wi-Fi" "Connecting to $ssid..." -i network-wireless
        if nmcli device wifi connect "$ssid" password "$pass"; then
            notify-send "Wi-Fi" "Successfully connected to $ssid" -i network-wireless
        else
            notify-send "Wi-Fi" "Failed to connect to $ssid" -i network-error
        fi
    fi
fi