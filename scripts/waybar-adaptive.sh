#!/usr/bin/env bash
# waybar-adaptive.sh — Color adaptativo del contenido de Waybar (barra
# transparente) según el brillo de la franja superior del wallpaper actual.
# Franja clara -> texto negro; franja oscura -> texto blanco.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALL_DIR="${WALLPAPERS_DIR:-$(dirname "$SCRIPT_DIR")/assets/wallpapers}"
CSS_FILE="$HOME/.config/waybar/adaptive.css"
STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/waybar-theme"
WHITE="#ffffff"
BLACK="#000000"

write_state() {
    local mode="$1"
    local color="$2"
    local state_dir
    state_dir="$(dirname "$STATE_FILE")"
    mkdir -p "$state_dir"
    printf '%s:%s\n' "$mode" "$color" > "${STATE_FILE}.tmp"
    mv -f "${STATE_FILE}.tmp" "$STATE_FILE"
}

current_color() {
    local state
    if [[ -f "$STATE_FILE" ]]; then
        state="$(<"$STATE_FILE")"
        case "$state" in
            manual:"$BLACK"|auto:"$BLACK") printf '%s\n' "$BLACK"; return ;;
            manual:"$WHITE"|auto:"$WHITE") printf '%s\n' "$WHITE"; return ;;
        esac
    fi
    if [[ -f "$CSS_FILE" ]] && grep -q "$WHITE" "$CSS_FILE"; then
        printf '%s\n' "$WHITE"
    else
        printf '%s\n' "$BLACK"
    fi
}

apply() {
    local color="$1"
    local tmp="${CSS_FILE}.tmp"
    mkdir -p "$(dirname "$CSS_FILE")"
    printf '#waybar,\n#waybar * {\n    color: %s;\n}\n' "$color" > "$tmp"
    mv -f "$tmp" "$CSS_FILE"
    pkill -SIGUSR2 -x waybar 2>/dev/null || true
}

# Toggle manual: invierte el color actual y lo conserva entre sesiones.
if [[ "${1:-}" == "toggle" ]]; then
    current="$(current_color)"
    [[ "$current" == "$WHITE" ]] && color="$BLACK" || color="$WHITE"
    write_state manual "$color"
    apply "$color"
    exit 0
fi

# Un wallpaper nuevo vuelve al modo automático. Sin "auto", el último
# color resuelto (manual o automático) se restaura al iniciar la sesión.
if [[ "${1:-}" != "auto" && -f "$STATE_FILE" ]]; then
    state="$(<"$STATE_FILE")"
    case "$state" in
        manual:"$BLACK"|auto:"$BLACK") color="$BLACK" ;;
        manual:"$WHITE"|auto:"$WHITE") color="$WHITE" ;;
        *) color="" ;;
    esac
    if [[ -n "$color" ]]; then
        apply "$color"
        exit 0
    fi
fi

# Resolver el wallpaper actual: cache -> primer archivo.
wall=""
[[ -f "$HOME/.cache/last_wallpaper" ]] && wall="$(cat "$HOME/.cache/last_wallpaper")"
[[ -f "$wall" ]] || wall="$(find "$WALL_DIR" -maxdepth 1 -type f | sort | head -1)"
[[ -f "$wall" ]] || exit 0

# Luminancia media de la franja superior (~3% del alto).
LUM="$(magick "$wall" -gravity north -crop 100%x3%+0+0 +repage \
       -resize 1x1! -colorspace Gray -format '%[fx:round(mean*255)]' info:)"

# Solo fondos claramente claros (>=170) usan texto negro.
(( LUM >= 170 )) && color="$BLACK" || color="$WHITE"
write_state auto "$color"
apply "$color"