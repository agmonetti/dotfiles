# Dotfiles — Arch Linux + Hyprland

Configuración personal de escritorio para **Arch Linux + Hyprland** (config Lua, formato
recomendado desde Hyprland 0.55 — hyprlang quedó deprecado).

## Características

- **Hyprland 0.55+** con config en **Lua** (`hyprland.lua` + módulos en `conf.d/`).
- Waybar, Mako, Kitty, Rofi, Yazi, Micro, Zsh + Powerlevel10k.
- Scripts de wallpapers (selector con Rofi), volumen, pomodoro y capturas.
- Instalación reproducible con GNU Stow y un `setup.sh` interactivo.

## Requisitos

- Arch Linux (o derivada) con el kernel y drivers de GPU listos.
- `git`, `stow` y `base-devel` (el instalador los instala si hace falta).

## Instalación

```bash
git clone https://github.com/agmonetti/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

El instalador es interactivo y pregunta qué hacer. También podés enlazar
manualmente cada módulo con `stow <módulo>` (ej: `stow hyprland waybar mako`).

## Estructura

```
.
├── hyprland/.config/hypr/        # Config principal de Hyprland (Lua)
│   ├── hyprland.lua              # Entry point (require de los módulos)
│   ├── conf.d/                   # Módulos: monitors, input, binds, ...
│   ├── hypridle.conf
│   ├── hyprlock.conf
│   └── hyprpaper.conf
├── waybar/  mako/  kitty/  rofi/  micro/  yazi/  yazi-dev/
├── zsh/                          # .zshrc + .p10k.zsh
├── scripts/                      # wallpapers, volumen, pomodoro
├── assets/                       # wallpapers + tema GRUB
├── system-configs/               # sddm.conf
├── git/.gitconfig.example        # plantilla (sin identidad)
└── setup.sh
```

## Variables de entorno

| Variable | Uso | Default |
|---|---|---|
| `DOTFILES_DIR` | Ruta del repo (scripts, waybar, autostart) | `$HOME/dotfiles` |
| `WALLPAPERS_DIR` | Carpeta de fondos | `$DOTFILES_DIR/assets/wallpapers` |
| `SCREENSHOTS_DIR` | Carpeta de capturas | `$HOME/Pictures/Screenshots` |

> `setup.sh` agrega `export DOTFILES_DIR="..."` a `~/.zshrc.local`.

## Cosas personales (no versionadas)

- `~/.zshrc.local` → alias, funciones o secretos propios (gitignoreado).
- `git/.gitconfig` → tu identidad real (gitignoreado). Usá `git/.gitconfig.example`
  como plantilla en otras máquinas.

## Validación de la config

```bash
hyprctl reload          # recarga la config en caliente
hyprctl configerrors    # muestra errores de parsing (Lua incluido)
hyprctl binds           # lista los atajos registrados
hyprctl monitors        # verifica monitores y escala
```
