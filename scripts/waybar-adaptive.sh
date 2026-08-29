#!/usr/bin/env bash
# waybar-adaptive.sh — Color adaptativo del contenido de Waybar (barra
# transparente) según el brillo de la franja superior del wallpaper actual.
# Franja clara -> texto negro; franja oscura -> texto blanco.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALL_DIR="${WALLPAPERS_DIR:-$(dirname "$SCRIPT_DIR")/assets/wallpapers}"
CSS_FILE="$HOME/.config/waybar/adaptive.css"

# Modo toggle manual: invierte el color actual si se pasa el argumento "toggle"
if [[ "${1:-}" == "toggle" ]]; then
    if [[ -f "$CSS_FILE" ]] && grep -q "#ffffff" "$CSS_FILE"; then
        color="#000000"
    else
        color="#ffffff"
    fi
    tmp="${CSS_FILE}.tmp"
    printf '#waybar,\n#waybar * {\n    color: %s;\n}\n' "$color" > "$tmp"
    mv -f "$tmp" "$CSS_FILE"
    pkill -SIGUSR2 -x waybar 2>/dev/null || true
    exit 0
fi

# 1) Resolver el wallpaper actual: cache propio -> waypaper -> primer archivo
wall=""
if [[ -f "$HOME/.cache/last_wallpaper" ]]; then
    wall="$(cat "$HOME/.cache/last_wallpaper")"
fi
if [[ ! -f "$wall" && -f "$HOME/.config/waypaper/config.ini" ]]; then
    wall="$(sed -n 's/^wallpaper = //p' "$HOME/.config/waypaper/config.ini" | tail -1)"
fi
if [[ ! -f "$wall" ]]; then
    wall="$(find "$WALL_DIR" -maxdepth 1 -type f | sort | head -1)"
fi
[[ -f "$wall" ]] || exit 0

# 2) Luminancia media de la franja superior (~3% del alto: cubre la barra de
#    26px incluso con escala 1.2; exacta porque los wallpapers son 16:9).
# ponytail: tira del strip superior del archivo; si algún día hay wallpapers
# verticales con fill, haría falta el recorte por geometría del monitor.
LUM="$(magick "$wall" -gravity north -crop 100%x3%+0+0 +repage \
       -resize 1x1! -colorspace Gray -format '%[fx:round(mean*255)]' info:)"

# 3) Decidir color: umbral alto (170) porque el texto blanco es legible en
# un rango más amplio de fondos que el negro (brillo propio en pantalla).
# Solo fondos claramente claros (>=170) usan texto negro.
(( LUM >= 170 )) && color="#000000" || color="#ffffff"
# ponytail: umbral calibrado con los 13 wallpapers del repo; sin histéresis.

# 4) Escribir CSS generado (atómico) y recargar Waybar
tmp="${CSS_FILE}.tmp"
printf '#waybar,\n#waybar * {\n    color: %s;\n}\n' "$color" > "$tmp"
mv -f "$tmp" "$CSS_FILE"
pkill -SIGUSR2 -x waybar 2>/dev/null || true