#!/bin/bash
# ~/.config/eww/scripts/toggle_menu.sh
# Toggle menu popup and handle click-outside/escape to close

# Check if menu is currently open
if eww active-windows | grep -q "menu_popup"; then
    # Menu is open, close it
    eww close menu_popup
    # Kill any existing close listener
    pkill -f "menu_close_listener"
else
    # Menu is closed, open it
    eww open menu_popup
    
    # Start the close listener in background
    ~/.config/eww/scripts/menu_close_listener.sh &
fi