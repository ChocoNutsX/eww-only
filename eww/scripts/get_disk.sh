#!/bin/bash
# ~/.config/eww/scripts/get_disk.sh
# Get disk usage for root partition

if command -v df >/dev/null 2>&1; then
    DISK=$(df -h / | awk 'NR==2{print $5}')
    echo "$DISK"
else
    echo "N/A"
fi