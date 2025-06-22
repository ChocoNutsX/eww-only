#!/bin/bash
# ~/.config/eww/scripts/get_ram.sh  
# Get RAM usage

if command -v free >/dev/null 2>&1; then
    RAM=$(free | grep Mem | awk '{printf("%.1f%%", $3/$2 * 100.0)}')
    echo "$RAM"
else
    # Fallback using /proc/meminfo
    TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    USED=$((TOTAL - AVAILABLE))
    PERCENT=$(awk "BEGIN {printf \"%.1f\", $USED/$TOTAL*100}")
    echo "${PERCENT}%"
fi