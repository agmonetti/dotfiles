#!/usr/bin/env bash
# Detecta DOTFILES_DIR desde su propia ubicación si no está definido
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$SCRIPT_DIR")}"
LAST="$HOME/.cache/last_wallpaper"
WALL_DIR="${WALLPAPERS_DIR:-$DOTFILES_DIR/assets/wallpapers}"

# Si no hay último fondo guardado, usa el primero de la carpeta
if [[ ! -f "$LAST" ]]; then
    wall=$(find "$WALL_DIR" -type f | sort | head -n 1)
else
    wall=$(cat "$LAST")
fi

[[ -z "$wall" || ! -f "$wall" ]] && exit 0

sleep 1
hyprctl hyprpaper preload "$wall"
for m in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$m,$wall"
done
