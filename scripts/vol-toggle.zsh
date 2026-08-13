#!/usr/bin/env zsh

# 1. Alternar el mute con tu comando exacto
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# 2. Leer el estado actual (wpctl devuelve algo como "Volume: 0.50" o "Volume: 0.50 [MUTED]")
STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# 3. Evaluar y notificar
if [[ $STATUS == *"[MUTED]"* ]]; then
    notify-send -h string:x-canonical-private-synchronous:volume "Audio" "Silenciado 󰝟"
else
    # Extraemos el número decimal (ej. 0.50) y lo multiplicamos por 100 para leerlo natural
    VOL=$(echo $STATUS | awk '{print int($2 * 100)}')
    notify-send -h string:x-canonical-private-synchronous:volume "Audio" "Activado al ${VOL}% 󰕾"
fi
