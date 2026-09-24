#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF' | rofi -dmenu -i -p 'Atajos' -no-custom \
    -theme-str 'window { width: 800px; height: 550px; location: center; anchor: center; }'
Hyprland · Aplicaciones
Super+Q                 Abrir Kitty
Super+E                 Abrir Yazi
Ctrl+Space              Abrir lanzador de aplicaciones (Rofi)
Super+Tab               Mostrar ventanas

Hyprland · Ventanas
Super+C                  Cerrar ventana
Super+V                  Alternar ventana flotante
Super+↑                  Pantalla completa
Super+B                  Minimizar/restaurar ventana
Super + arrastrar izq.   Mover ventana con el mouse
Super + arrastrar der.   Redimensionar ventana con el mouse

Hyprland · Escritorios
Super+D                  Enfocar escritorio vacío
Super+1…0                Cambiar al escritorio 1…10
Super+Shift+1…0          Mover ventana al escritorio 1…10

Hyprland · Personalización y capturas
Super+W                  Cambiar fondo de pantalla
Super+Shift+W            Alternar tema de Waybar
Print                    Captura de una región
Shift+Print              Captura de pantalla completa

Hyprland · Energía
Super+Shift+B            Perfil de energía balanceado
Super+Shift+P            Perfil de energía rendimiento
Super+Shift+S            Perfil de energía ahorro

Hyprland · Audio y brillo
Volumen + / -            Subir / bajar volumen
Mute                     Alternar silencio
Brillo + / -             Subir / bajar brillo

Kitty
Ctrl+Shift+↑/↓           Navegar entre prompts
Ctrl+Shift+PageUp/Down    Navegar entre prompts
Ctrl+Shift+Z             Volver al prompt actual
Ctrl+Ñ                   Abrir división horizontal
Alt+←/→                  Cambiar entre ventanas
Ctrl+Shift+T             Alternar tema claro/oscuro
EOF
