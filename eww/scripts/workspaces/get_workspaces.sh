#!/bin/bash
# ~/.config/eww/scripts/workspaces/get_workspaces.sh
# Get dynamic list of workspaces in JSON format for eww

# Get current workspace
current=$(hyprctl activewindow | grep 'workspace:' | awk '{print $2}' 2>/dev/null || echo "1")

# Get workspaces with windows
used_workspaces=$(hyprctl clients -j 2>/dev/null | grep -o '"workspace":{"id":[0-9]*' | grep -o '[0-9]*' | sort -n | uniq 2>/dev/null)

# If that doesn't work, try alternative method
if [ -z "$used_workspaces" ]; then
    used_workspaces=$(hyprctl workspaces 2>/dev/null | grep 'workspace ID' | awk '{print $3}' | sort -n)
fi

# Combine current + used workspaces
all_workspaces=$(echo -e "$current\n$used_workspaces" | sort -n | uniq | grep -v '^$')

# Convert to JSON array format for eww
echo -n "["
first=true
for ws in $all_workspaces; do
    if [ "$first" = true ]; then
        first=false
    else
        echo -n ", "
    fi
    echo -n "\"$ws\""
done
echo "]"