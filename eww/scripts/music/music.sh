#!/bin/bash
# ~/.config/eww/scripts/music/music.sh
# Fixed music control script

# Function to get the best available player
get_active_player() {
    # Get list of all players
    players=$(playerctl -l 2>/dev/null)
    
    # Priority order: spotify > other music players > browsers
    for player in $players; do
        case $player in
            *spotify*)
                # Check if Spotify is actually playing or paused (has content)
                if playerctl -p "$player" status &>/dev/null; then
                    echo "$player"
                    return
                fi
                ;;
        esac
    done
    
    # If no Spotify, try other dedicated music players
    for player in $players; do
        case $player in
            *vlc*|*mpv*|*rhythmbox*|*clementine*|*strawberry*)
                if playerctl -p "$player" status &>/dev/null; then
                    echo "$player"
                    return
                fi
                ;;
        esac
    done
    
    # Fallback to any available player (including browsers)
    for player in $players; do
        if playerctl -p "$player" status &>/dev/null; then
            echo "$player"
            return
        fi
    done
    
    echo ""
}

get_music_title() {
    player=$(get_active_player)
    if [ -n "$player" ]; then
        status=$(playerctl -p "$player" status 2>/dev/null)
        if [ "$status" == "Playing" ] || [ "$status" == "Paused" ]; then
            title=$(playerctl -p "$player" metadata --format '{{title}}' 2>/dev/null)
            if [ -n "$title" ] && [ "$title" != "No title" ]; then
                echo "$title"
            else
                echo "Unknown Title"
            fi
        else
            echo "Not Playing"
        fi
    else
        echo "Not Playing"
    fi
}

get_music_artist() {
    player=$(get_active_player)
    if [ -n "$player" ]; then
        status=$(playerctl -p "$player" status 2>/dev/null)
        if [ "$status" == "Playing" ] || [ "$status" == "Paused" ]; then
            artist=$(playerctl -p "$player" metadata --format '{{artist}}' 2>/dev/null)
            if [ -n "$artist" ] && [ "$artist" != "No artist" ]; then
                echo "$artist"
            else
                echo "Unknown Artist"
            fi
        else
            echo "No Music"
        fi
    else
        echo "No Music"
    fi
}

get_music_status() {
    player=$(get_active_player)
    if [ -n "$player" ]; then
        status=$(playerctl -p "$player" status 2>/dev/null)
        case "$status" in
            "Playing") echo "playing" ;;
            "Paused") echo "paused" ;;
            *) echo "stopped" ;;
        esac
    else
        echo "stopped"
    fi
}

music_toggle() {
    player=$(get_active_player)
    if [ -n "$player" ]; then
        playerctl -p "$player" play-pause 2>/dev/null
    fi
}

music_next() {
    player=$(get_active_player)
    if [ -n "$player" ]; then
        playerctl -p "$player" next 2>/dev/null
    fi
}

music_prev() {
    player=$(get_active_player)
    if [ -n "$player" ]; then
        playerctl -p "$player" previous 2>/dev/null
    fi
}

# Main
case "$1" in
    "--title"   ) get_music_title ;;
    "--artist"  ) get_music_artist ;;
    "--status"  ) get_music_status ;;
    "--toggle"  ) music_toggle ;;
    "--next"    ) music_next ;;
    "--prev"    ) music_prev ;;
    *)
        echo "Usage: $0 {--title|--artist|--status|--toggle|--next|--prev}"
        ;;
esac