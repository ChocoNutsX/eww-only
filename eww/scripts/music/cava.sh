#!/bin/bash
# ~/.config/eww/scripts/music/cava.sh
# Get cava output for eww

CAVA_PID_FILE="/tmp/eww_cava.pid"

start_cava() {
    # Kill existing cava if running
    if [ -f "$CAVA_PID_FILE" ]; then
        kill "$(cat $CAVA_PID_FILE)" 2>/dev/null
        rm -f "$CAVA_PID_FILE"
    fi
    
    # Start cava with compact output
    cava -p ~/.config/cava/config | while read -r line; do
        # Convert cava output to visual bars
        bars=""
        for ((i=0; i<${#line}; i++)); do
            char="${line:$i:1}"
            case "$char" in
                "0") bars="${bars} " ;;
                "1") bars="${bars}▁" ;;
                "2") bars="${bars}▂" ;;
                "3") bars="${bars}▃" ;;
                "4") bars="${bars}▄" ;;
                "5") bars="${bars}▅" ;;
                "6") bars="${bars}▆" ;;
                "7") bars="${bars}▇" ;;
                *) bars="${bars}█" ;;
            esac
        done
        echo "$bars" > /tmp/eww_cava_output
    done &
    
    echo $! > "$CAVA_PID_FILE"
}

stop_cava() {
    if [ -f "$CAVA_PID_FILE" ]; then
        kill "$(cat $CAVA_PID_FILE)" 2>/dev/null
        rm -f "$CAVA_PID_FILE"
        rm -f /tmp/eww_cava_output
    fi
}

get_cava_output() {
    if [ -f /tmp/eww_cava_output ]; then
        cat /tmp/eww_cava_output
    else
        echo "♪♪♪♪♪♪♪♪"  # Fallback
    fi
}

case "$1" in
    "--start") start_cava ;;
    "--stop") stop_cava ;;
    "--output") get_cava_output ;;
    *)
        echo "Usage: $0 {--start|--stop|--output}"
        ;;
esac