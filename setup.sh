#!/usr/bin/env bash
set -euo pipefail

# ==============================================================
#  Instalador de dotfiles (Arch Linux + Hyprland)
#  Uso: ./setup.sh
#  Enlaza los módulos con GNU Stow, instala paquetes y deja el
#  entorno listo. Es interactivo; contestá s/n según prefieras.
# ==============================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_USER="$(whoami)"

ask_yes_no() {
    local prompt="$1"
    while true; do
        read -p "$(echo -e "${YELLOW}? ${prompt} [s/N]: ${NC}")" yn
        case $yn in
            [Ss]*) return 0 ;;
            [Nn]*|"") return 1 ;;
            *) echo -e "${RED}Por favor respondé 's' para sí o 'n' para no.${NC}" ;;
        esac
    done
}

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}   Instalador de Dotfiles (Hyprland)  ${NC}"
echo -e "${BLUE}   Repo: ${DOTFILES_DIR}${NC}"
echo -e "${BLUE}=======================================${NC}\n"

sudo -v

# --- 1. DEPENDENCIAS BASE Y AUR HELPER (yay) ---
if ask_yes_no "¿Instalar dependencias base y yay (AUR helper)?"; then
    echo -e "${BLUE}-> Preparando el terreno...${NC}"
    sudo pacman -S --needed --noconfirm git base-devel stow

    if ! command -v yay &> /dev/null; then
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        (cd /tmp/yay && makepkg -si --noconfirm)
        rm -rf /tmp/yay
    fi
    echo -e "${GREEN}[OK] Dependencias listas.${NC}\n"
fi

# --- 2. INSTALACIÓN DE SOFTWARE ---
if ask_yes_no "¿Instalar todo el software desde las listas (pkg-pacman / pkg-aur)?"; then
    echo -e "${BLUE}-> Instalando software...${NC}"
    pacman_pkgs=$(grep -vE '^\s*#|^\s*$' "$DOTFILES_DIR/pkg-pacman.txt" | tr '\n' ' ')
    [ -n "$pacman_pkgs" ] && sudo pacman -S --needed --noconfirm $pacman_pkgs

    if command -v yay &> /dev/null; then
        aur_pkgs=$(grep -vE '^\s*#|^\s*$' "$DOTFILES_DIR/pkg-aur.txt" | tr '\n' ' ')
        [ -n "$aur_pkgs" ] && yay -S --needed --noconfirm $aur_pkgs
    fi
    echo -e "${GREEN}[OK] Software instalado.${NC}\n"
fi

# --- 3. ENLACE DE CONFIGURACIONES (STOW) ---
if ask_yes_no "¿Enlazar las configuraciones con Stow?"; then
    echo -e "${BLUE}-> Enlazando configuraciones...${NC}"
    cd "$DOTFILES_DIR"

    for f in .zshrc .p10k.zsh; do
        if [ -f ~/"$f" ] && [ ! -L ~/"$f" ]; then
            mv ~/"$f" ~/"$f".bak
            echo "   Respaldo: $f movido a $f.bak"
        fi
    done

    for module in hyprland waybar mako kitty rofi micro yazi yazi-dev zsh scripts apps; do
        if [ -d "$DOTFILES_DIR/$module" ]; then
            stow -t "$HOME" "$module" 2>/dev/null || stow -t "$HOME" --adopt "$module"
            echo "   Enlazado: $module"
        fi
    done

    # DOTFILES_DIR para scripts (waybar, hyprland, wallpapers)
    if [ -f ~/.zshrc.local ]; then
        if ! grep -q 'DOTFILES_DIR' ~/.zshrc.local; then
            printf '\nexport DOTFILES_DIR="%s"\n' "$DOTFILES_DIR" >> ~/.zshrc.local
        fi
    else
        printf 'export DOTFILES_DIR="%s"\n' "$DOTFILES_DIR" > ~/.zshrc.local
    fi

    if [ "$SHELL" != "$(command -v zsh)" ]; then
        echo "   Cambiando shell por defecto a Zsh..."
        chsh -s "$(command -v zsh)"
    fi
    echo -e "${GREEN}[OK] Configuraciones enlazadas.${NC}\n"
fi

# --- 4. WALLPAPERS ---
if ask_yes_no "¿Copiar los wallpapers a ~/Pictures/Wallpapers?"; then
    mkdir -p ~/Pictures/Wallpapers
    [ -d "$DOTFILES_DIR/assets/wallpapers" ] && cp -r "$DOTFILES_DIR/assets/wallpapers/"* ~/Pictures/Wallpapers/
    echo -e "${GREEN}[OK] Wallpapers copiados.${NC}\n"
fi

# --- FINALIZAR ---
echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}   Ejecución Finalizada Exitosamente   ${NC}"
echo -e "${GREEN}=======================================${NC}"
echo ""
echo "Siguientes pasos:"
echo " 1. Reiniciá la sesión (o: exec zsh) para cargar DOTFILES_DIR."
echo " 2. Verificá Hyprland con: hyprctl reload && hyprctl configerrors"
echo " 3. Personalizá tus alias/funciones en ~/.zshrc.local (no versionado)."
