#!/bin/bash
# ~/.config/eww/scripts/audio/get_audio.sh
# Simple audio status script (for backward compatibility)

# Try PipeWire/WirePlumber first (common on modern systems)
if command -v wpctl >/dev/null 2>&1; then
    # Get default sink volume
    VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
    MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "true" || echo "false")
    
    if [ "$MUTED" = "true" ]; then
        echo "🔇 Muted"
    else
        echo "🔊 ${VOLUME}%"
    fi

# Fallback to PulseAudio
elif command -v pactl >/dev/null 2>&1; then
    # Get default sink info
    SINK=$(pactl get-default-sink)
    VOLUME=$(pactl get-sink-volume $SINK | head -n 1 | awk '{print $5}' | sed 's/%//')
    MUTED=$(pactl get-sink-mute $SINK | awk '{print $2}')
    
    if [ "$MUTED" = "yes" ]; then
        echo "🔇 Muted"
    else
        echo "🔊 ${VOLUME}%"
    fi

# Fallback to ALSA
elif command -v amixer >/dev/null 2>&1; then
    # Get master volume
    VOLUME=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
    MUTED=$(amixer get Master | tail -n1 | grep -q "\[off\]" && echo "true" || echo "false")
    
    if [ "$MUTED" = "true" ]; then
        echo "🔇 Muted"
    else
        echo "🔊 ${VOLUME}%"
    fi
else
    echo "🔊 N/A"
fi