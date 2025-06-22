#!/bin/bash
# ~/.config/eww/scripts/get_network_speed.sh
# Get network interface speed

# Find the active network interface
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)

if [ -n "$INTERFACE" ]; then
    # Get interface speed from ethtool or iwconfig
    if command -v ethtool >/dev/null 2>&1; then
        SPEED=$(ethtool "$INTERFACE" 2>/dev/null | grep "Speed:" | awk '{print $2}')
        if [ -n "$SPEED" ]; then
            echo "$SPEED"
        else
            echo "Connected"
        fi
    elif command -v iwconfig >/dev/null 2>&1; then
        SPEED=$(iwconfig "$INTERFACE" 2>/dev/null | grep "Bit Rate" | awk '{print $2}' | cut -d: -f2)
        if [ -n "$SPEED" ]; then
            echo "${SPEED}b/s"
        else
            echo "Connected"
        fi
    else
        echo "Connected"
    fi
else
    echo "No Connection"
fi