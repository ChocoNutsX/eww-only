#!/bin/bash
# ~/.config/eww/scripts/center/get_active_app.sh
# Get the active application name

# Get active window info
active_window=$(hyprctl activewindow 2>/dev/null)

if [ -n "$active_window" ] && [ "$active_window" != "Invalid" ]; then
    # Try to get the application class first
    app_class=$(echo "$active_window" | grep "class:" | awk '{print $2}')
    
    # Try to get the window title as fallback
    app_title=$(echo "$active_window" | grep "title:" | cut -d':' -f2- | sed 's/^ *//')
    
    # Clean up common app names for better display
    case "$app_class" in
        "firefox"|"Firefox") echo "🌐 Firefox" ;;
        "code"|"Code") echo "💻 Code" ;;
        "chrome"|"google-chrome"|"Google-chrome") echo "🌐 Chrome" ;;
        "spotify"|"Spotify") echo "🎵 Spotify" ;;
        "discord"|"Discord") echo "💬 Discord" ;;
        "telegram"|"Telegram") echo "💬 Telegram" ;;
        "nautilus"|"Nautilus") echo "📁 Files" ;;
        "kitty"|"Alacritty"|"gnome-terminal") echo "💻 Terminal" ;;
        "gimp"|"GIMP") echo "🎨 GIMP" ;;
        "steam"|"Steam") echo "🎮 Steam" ;;
        *)
            # If app_class is not recognized, use title or class
            if [ -n "$app_title" ] && [ ${#app_title} -lt 30 ]; then
                echo "📋 $app_title"
            elif [ -n "$app_class" ]; then
                echo "🪟 $app_class"
            else
                echo "🏠 Desktop"
            fi
            ;;
    esac
else
    echo "🏠 Desktop"
fi