#!/usr/bin/env bash
# ==========================================
# KITTY THEME TOGGLE - oscuro <-> claro
# ==========================================
# Alterna el symlink themes/active.conf entre dark y light
# y aplica el cambio en vivo a todas las ventanas.
# Sincroniza tambien el colorscheme de micro.
set -euo pipefail

CFG_DIR="${KITTY_CONFIG_DIR:-$HOME/.config/kitty}"
THEMES="$CFG_DIR/themes"
ACTIVE="$THEMES/active.conf"

MICRO_CS="$HOME/.config/micro/colorschemes/kitty-sync.micro"

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

# Sincroniza el colorscheme de micro con el tema activo
if [[ "$next" == "light.conf" ]]; then
    ln -sfn kitty-light.micro "$MICRO_CS"
else
    ln -sfn kitty-dark.micro "$MICRO_CS"
fi

# Refresca en vivo los micro abiertos en esta instancia: > reload
# recarga colorscheme/sintaxis/settings sin descartar cambios del buffer.
kitty @send-text --match 'cmdline:micro' $'\x05reload\r' 2>/dev/null || true
