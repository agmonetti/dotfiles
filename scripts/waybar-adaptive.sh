#!/usr/bin/env bash
# waybar-adaptive.sh — Color adaptativo del contenido de Waybar (barra
# transparente) según el brillo de la franja superior del wallpaper actual.
# Franja clara -> texto negro; franja oscura -> texto blanco.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALL_DIR="${WALLPAPERS_DIR:-$(dirname "$SCRIPT_DIR")/assets/wallpapers}"
CSS_FILE="$HOME/.config/waybar/adaptive.css"

# Esperar a waybar (máx 5s) y recargar estilo
apply() {
    local tmp="${CSS_FILE}.tmp"
    printf '#waybar,\n#waybar * {\n    color: %s;\n}\n' "$1" > "$tmp"
    mv -f "$tmp" "$CSS_FILE"
    for _i in 1 2 3 4 5; do pgrep -x waybar >/dev/null && break; sleep 1; done
    pkill -SIGUSR2 -x waybar 2>/dev/null || true
}

# Toggle manual: invierte el color actual
if [[ "${1:-}" == "toggle" ]]; then
    [[ -f "$CSS_FILE" ]] && grep -q "#ffffff" "$CSS_FILE" && apply "#000000" || apply "#ffffff"
    exit 0
fi

# 1) Resolver el wallpaper actual: cache -> primer archivo
wall=""
[[ -f "$HOME/.cache/last_wallpaper" ]] && wall="$(cat "$HOME/.cache/last_wallpaper")"
[[ -f "$wall" ]] || wall="$(find "$WALL_DIR" -maxdepth 1 -type f | sort | head -1)"
[[ -f "$wall" ]] || exit 0

# 2) Luminancia media de la franja superior (~3% del alto)
# ponytail: tira del strip superior del archivo; si algún día hay wallpapers
# verticales con fill, haría falta el recorte por geometría del monitor.
LUM="$(magick "$wall" -gravity north -crop 100%x3%+0+0 +repage \
       -resize 1x1! -colorspace Gray -format '%[fx:round(mean*255)]' info:)"

# 3) Decidir color (umbral 170: solo fondos claramente claros usan texto negro)
# ponytail: umbral calibrado con los 13 wallpapers del repo; sin histéresis.
(( LUM >= 170 )) && apply "#000000" || apply "#ffffff"