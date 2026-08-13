#!/bin/bash

choice=$(printf "⏻ Apagar\n Reiniciar\n Suspender\n Cerrar sesión" | \
    rofi -dmenu -p "Power")

case "$choice" in
    "⏻ Apagar")
        systemctl poweroff
        ;;
    " Reiniciar")
        systemctl reboot
        ;;
    " Suspender")
        systemctl suspend
        ;;
    " Cerrar sesión")
        hyprctl dispatch exit
        ;;
esac
