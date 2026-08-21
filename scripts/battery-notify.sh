#!/usr/bin/env zsh

while true; do
    BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    if [[ "$BATTERY" -le 20 && "$STATUS" == "Discharging" ]]; then
        notify-send \
            -u critical \
            -h string:x-canonical-private-synchronous:battery \
            "Batería baja" \
            "Queda ${BATTERY}% de batería 󰁻"

        sleep 300
    else
        sleep 60
    fi
done
