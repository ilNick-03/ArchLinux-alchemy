#!/bin/bash
# Copyright (C) 2026, Nicolas Scalese
# Licensed under the GNU GPL v3 or later. Info: https://www.gnu.org/licenses/gpl-3.0.html


# --- BATTERY CONSUMPTION CALCULATOR ---
# A high-precision utility for analyzing energy efficiency during active use or suspension.
# It leverages 'upower' metrics to calculate discharge rates and estimated autonomy.
#
# Documentation: To fetch data, run before and after the observation period:
# 'upower -i /org/freedesktop/UPower/devices/battery_BAT0'
# Or simply:    'upower --battery'


echo " "
echo "***** Battery Consumption Calculator (based on 'upower') *****"
echo " "


# --- DATA INPUT ---
read -p "  Initial energy (Wh): " E1_IN
read -p "  Final energy (Wh): " E2_IN
read -p "  Max battery capacity (energy-full) (Wh): " E_FULL_IN
read -p "  Start time (24h format HH:MM): " TIME_START
read -p "  End time (24h format HH:MM): " TIME_END


# --- ELAPSED TIME CALCULATION ---
# Deconstructing hours and minutes using ':' as delimiter
IFS=: read start_h start_m <<< "$TIME_START"
IFS=: read end_h end_m <<< "$TIME_END"

# Converting timestamps to absolute minutes from midnight using base-10 (10# prefix)
start_m_total=$(( 10#$start_h * 60 + 10#$start_m ))
end_m_total=$(( 10#$end_h * 60 + 10#$end_m ))

# Calculating the time delta
T=$(( end_m_total - start_m_total ))

# Adjusting for midnight crossing (e.g., 23:30 to 08:15)
if (( T < 0 )); then
    T=$(( T + 1440 ))
fi

echo "  -> Calculated elapsed time: $T minutes"
echo " "


# --- FORMATTING UTILITIES ---
# Normalizing input to use dots as decimal separators for 'bc'
to_point() { echo ${1//,/.} ; }

# Advanced to_comma: replaces dot with comma AND adds leading zero if missing
to_comma() { 
    local val="${1//./,}"
    # If it starts with a comma, prepend 0
    [[ "$val" =~ ^, ]] && val="0$val"
    # If it starts with a negative comma (-,), make it -0,
    [[ "$val" =~ ^-, ]] && val="-0,${val#-,}"
    echo "$val"
}

E1=$(to_point $E1_IN)
E2=$(to_point $E2_IN)
E_FULL=$(to_point $E_FULL_IN)


# --- CORE CALCULATIONS (using 'bc' for floating point precision) ---
# Calculate total Wh lost, average wattage draw, and percentage metrics
WH_LOST_RAW=$(echo "scale=10; $E1 - $E2" | bc)
WATT_RAW=$(echo "scale=10; (60 * $WH_LOST_RAW) / $T" | bc)
DELTA_P_RAW=$(echo "scale=10; $WH_LOST_RAW / $E_FULL" | bc)
PH_RAW=$(echo "scale=10; (60 * $DELTA_P_RAW) / $T" | bc)

# Quantize values to 4 decimal places for the final report
fmt() { echo "scale=4; $1 / 1" | bc ; }

WH_LOST=$(fmt $WH_LOST_RAW)
WATT=$(fmt $WATT_RAW)
DELTA_P=$(fmt $DELTA_P_RAW)
PH=$(fmt $PH_RAW)

PERCENT_P=$(echo "scale=2; $DELTA_P_RAW * 100 / 1" | bc)
PERCENT_PH=$(echo "scale=2; $PH_RAW * 100 / 1" | bc)

# Calculate estimated time until depletion
AUTONOMY_RAW=$(echo "scale=1; $E2 / $WATT_RAW" | bc)
AUTONOMY=$(to_comma $AUTONOMY_RAW)


# --- FINAL TABULAR OUTPUT ---
echo "+------------------------------------------------------+"
printf "| %-52s |\n" "                     RESULTS:"
echo "+-----------------------+------------------------------+"
printf "| %-21s | %-28s |\n" "Consumed energy:" "$(to_comma $WH_LOST) Wh"
printf "| %-21s | %-28s |\n" "Average power:" "$(to_comma $WATT) W"
printf "| %-21s | %-28s |\n" "Energy percent:" "$(to_comma $DELTA_P) ($(to_comma $PERCENT_P)%)"
printf "| %-21s | %-28s |\n" "Hourly consumption:" "$(to_comma $PH) ($(to_comma $PERCENT_PH)%/h)"
echo "+-----------------------+------------------------------+"
printf "| %-52s |\n" "Estimated autonomy in this state: $AUTONOMY hours"
echo "+------------------------------------------------------+"
echo " "
