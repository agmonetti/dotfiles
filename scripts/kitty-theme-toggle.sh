#!/usr/bin/env bash
# ==========================================
# KITTY THEME TOGGLE - oscuro <-> claro
# ==========================================
# Alterna el symlink themes/active.conf entre dark y light
# y aplica el cambio en vivo a todas las ventanas.
set -euo pipefail

CFG_DIR="${KITTY_CONFIG_DIR:-$HOME/.config/kitty}"
THEMES="$CFG_DIR/themes"
ACTIVE="$THEMES/active.conf"

# Tema actual segun el symlink
current="$(readlink "$ACTIVE" 2>/dev/null || echo dark.conf)"

if [[ "$current" == "dark.conf" ]]; then
    next="light.conf"
else
    next="dark.conf"
fi

# Apunta el symlink al nuevo tema (persistente tras reinicio)
ln -sfn "$next" "$ACTIVE"

# Aplica el cambio en vivo a todas las ventanas
kitty @set-colors --all --configured "$THEMES/$next" 2>/dev/null || true

# Notificacion discreta
notify-send "Kitty" "Tema $(basename "$next" .conf)" 2>/dev/null || true
