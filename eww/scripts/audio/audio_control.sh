#!/bin/bash
# ~/.config/eww/scripts/audio/audio_control.sh
# Enhanced audio script for revealer widget - returns individual values

# Function to get volume value only (for slider)
get_volume() {
    if command -v wpctl >/dev/null 2>&1; then
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
    elif command -v pactl >/dev/null 2>&1; then
        SINK=$(pactl get-default-sink)
        pactl get-sink-volume $SINK | head -n 1 | awk '{print $5}' | sed 's/%//'
    elif command -v amixer >/dev/null 2>&1; then
        amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/"
    else
        echo "50"
    fi
}

# Function to get mute status only (true/false)
get_mute_status() {
    if command -v wpctl >/dev/null 2>&1; then
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "true" || echo "false"
    elif command -v pactl >/dev/null 2>&1; then
        SINK=$(pactl get-default-sink)
        MUTED=$(pactl get-sink-mute $SINK | awk '{print $2}')
        [ "$MUTED" = "yes" ] && echo "true" || echo "false"
    elif command -v amixer >/dev/null 2>&1; then
        amixer get Master | tail -n1 | grep -q "\[off\]" && echo "true" || echo "false"
    else
        echo "false"
    fi
}

# Function to get audio device name
get_audio_device() {
    if command -v wpctl >/dev/null 2>&1; then
        wpctl status | grep -A5 "Audio" | grep "*" | awk -F. '{print $2}' | cut -c2- | cut -d'[' -f1 | sed 's/^ *//g' | head -1
    elif command -v pactl >/dev/null 2>&1; then
        pactl get-default-sink | xargs pactl list sinks | grep "Description:" | cut -d: -f2 | sed 's/^ *//'
    else
        echo "Default Audio Device"
    fi
}

# Main script - handle command line arguments
case "$1" in
    "--volume")
        get_volume
        ;;
    "--mute")
        get_mute_status
        ;;
    "--device")
        get_audio_device
        ;;
    "--toggle-mute")
        if command -v wpctl >/dev/null 2>&1; then
            wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        elif command -v pactl >/dev/null 2>&1; then
            pactl set-sink-mute @DEFAULT_SINK@ toggle
        fi
        ;;
    "--set-volume")
        if [ -n "$2" ]; then
            if command -v wpctl >/dev/null 2>&1; then
                wpctl set-volume @DEFAULT_AUDIO_SINK@ "${2}%"
            elif command -v pactl >/dev/null 2>&1; then
                pactl set-sink-volume @DEFAULT_SINK@ "${2}%"
            fi
        fi
        ;;
    *)
        # Default: return formatted status (like original script)
        VOLUME=$(get_volume)
        MUTED=$(get_mute_status)
        
        if [ "$MUTED" = "true" ]; then
            echo "🔇 Muted"
        else
            echo "🔊 ${VOLUME}%"
        fi
        ;;
esac