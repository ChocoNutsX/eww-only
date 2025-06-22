#!/bin/bash
# ~/.config/eww/scripts/get_cpu.sh
# Get CPU usage percentage

if command -v top >/dev/null 2>&1; then
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo "${CPU}%"
elif command -v iostat >/dev/null 2>&1; then
    CPU=$(iostat -c 1 2 | tail -1 | awk '{print 100-$6}')
    printf "%.1f%%\n" "$CPU"
else
    # Fallback using /proc/stat
    CPU=$(awk '{u=$2+$4; t=$2+$3+$4+$5; if (NR==1){u1=u; t1=t;} else print (u-u1) * 100 / (t-t1)}' <(grep 'cpu ' /proc/stat; sleep 1; grep 'cpu ' /proc/stat))
    printf "%.1f%%\n" "$CPU"
fi