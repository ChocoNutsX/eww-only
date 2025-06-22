#!/bin/bash
# ~/.config/eww/scripts/menu_close_listener.sh
# Handle closing menu on escape key or focus loss (Hyprland/Wayland compatible)

# Function to close menu
close_menu() {
    eww close menu_popup
    exit 0
}

# Trap signals to clean up
trap close_menu EXIT INT TERM

# Method 1: Monitor hyprctl events for window focus changes
if command -v hyprctl >/dev/null 2>&1; then
    # Listen for window focus events
    hyprctl -j dispatch focusmonitor 0 >/dev/null 2>&1
    
    # Monitor for focus changes - if focus goes to another window, close menu
    socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | \
    while read -r event; do
        # Check if the event indicates a window focus change
        if echo "$event" | grep -q "activewindow\|workspace\|urgent"; then
            # Check if menu is still active
            if eww active-windows | grep -q "menu_popup"; then
                # Small delay to prevent immediate closing
                sleep 0.1
                # Close menu if focus changed
                close_menu
            fi
        fi
    done &
fi

# Method 2: Simple timeout approach (fallback)
# Close menu after 30 seconds of inactivity
sleep 30 && close_menu &

# Method 3: Monitor for escape key using wev (if available)
if command -v wev >/dev/null 2>&1; then
    # Monitor keyboard events for escape key
    wev | while read -r line; do
        if echo "$line" | grep -q "key.*Escape.*pressed"; then
            close_menu
        fi
    done &
fi

# Keep the script running until menu is closed
while eww active-windows | grep -q "menu_popup"; do
    sleep 0.5
done