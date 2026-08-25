#!/usr/bin/env zsh

NOTIFIED=false

while true; do
    BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    # Notifica una única vez al llegar al 20% mientras descarga
    if [[ "$BATTERY" -le 20 && "$STATUS" == "Discharging" && "$NOTIFIED" == false ]]; then
        notify-send \
            -u critical \
            -t 10000 \
            -h string:x-canonical-private-synchronous:battery \
            "Batería baja" \
            "Queda ${BATTERY}% de batería 󰁻"
        NOTIFIED=true
    fi

    # Rearma la notificación solo si se recarga por encima del umbral
    if [[ "$BATTERY" -gt 20 || "$STATUS" == "Charging" || "$STATUS" == "Full" ]]; then
        NOTIFIED=false
    fi

    sleep 60
done
