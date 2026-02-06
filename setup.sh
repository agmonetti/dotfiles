#!/bin/bash

# --- VARIABLES Y COLORES ---
# Colores ANSI para legibilidad sin ser estridentes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color
DOTFILES_DIR="$HOME/dotfiles"

echo -e "${BLUE}[INFO] Iniciando configuracion de Dotfiles...${NC}"

# Solicitar permisos de sudo al inicio
sudo -v

# --- 1. DEPENDENCIAS ---
echo -e "${BLUE}[1/5] Verificando dependencias...${NC}"
cd "$DOTFILES_DIR"
if ! command -v stow &> /dev/null; then
    sudo pacman -S --needed --noconfirm git stow
fi

# --- 2. STOW (Configs de usuario) ---
echo -e "${BLUE}[2/5] Enlazando archivos de configuracion...${NC}"

# Backup preventivo de bashrc si existe y no es enlace
if [ -f ~/.bashrc ] && [ ! -L ~/.bashrc ]; then
    mv ~/.bashrc ~/.bashrc.bak
    echo "  -> .bashrc existente respaldado como .bashrc.bak"
fi

stow bash
stow git
# stow nvim (Descomentar si es necesario)

echo -e "${GREEN}  [OK] Enlaces creados.${NC}"

# --- 3. ASSETS (Wallpapers) ---
echo -e "${BLUE}[3/5] Copiando recursos graficos...${NC}"
mkdir -p ~/Pictures/Wallpapers

if [ -d "$DOTFILES_DIR/assets/wallpapers" ]; then
    cp -r "$DOTFILES_DIR/assets/wallpapers/"* ~/Pictures/Wallpapers/
    echo "  -> Wallpapers copiados a ~/Pictures/Wallpapers"
else
    echo -e "${RED}  [!] No se encontro la carpeta assets/wallpapers${NC}"
fi

# --- 4. GNOME (Dconf) ---
echo -e "${BLUE}[4/5] Restaurando configuracion de GNOME...${NC}"

load_dconf() {
    if [ -f "$1" ]; then
        dconf load "$2" < "$1"
        echo "  -> Cargado: $(basename $1)"
    else
        echo -e "${RED}  [!] Archivo no encontrado: $(basename $1)${NC}"
    fi
}

load_dconf "gnome/desktop-settings.dconf" "/org/gnome/desktop/"
load_dconf "gnome/shell-settings.dconf" "/org/gnome/shell/"
load_dconf "gnome/mutter-settings.dconf" "/org/gnome/mutter/"
load_dconf "gnome/custom-shortcuts.dconf" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/" 

# --- 5. GRUB (System) ---
echo -e "${BLUE}[5/5] Configurando tema de GRUB...${NC}"
GRUB_THEME_DIR="$DOTFILES_DIR/assets/grub"

if [ -d "$GRUB_THEME_DIR" ] && [ "$(ls -A $GRUB_THEME_DIR)" ]; then
    THEME_NAME=$(ls "$GRUB_THEME_DIR" | head -1)
    TARGET_THEME="/boot/grub/themes/$THEME_NAME"
    
    echo "  -> Tema detectado: $THEME_NAME"
    
    sudo mkdir -p /boot/grub/themes
    sudo cp -r "$GRUB_THEME_DIR/$THEME_NAME" /boot/grub/themes/
    
    # Configuracion segura de /etc/default/grub
    # 1. Comenta cualquier configuracion previa de tema
    sudo sed -i '/^GRUB_THEME=/s/^/#/' /etc/default/grub
    
    # 2. Agrega la nueva configuracion si no existe
    if ! grep -q "GRUB_THEME=\"$TARGET_THEME/theme.txt\"" /etc/default/grub; then
        echo "GRUB_THEME=\"$TARGET_THEME/theme.txt\"" | sudo tee -a /etc/default/grub > /dev/null
    fi
    
    echo "  -> Regenerando grub.cfg..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null
    echo -e "${GREEN}  [OK] Tema de GRUB aplicado.${NC}"
else
    echo "  [i] No se detectaron temas de GRUB en assets/grub. Omitiendo."
fi

# --- FINALIZAR ---
echo -e "\n${GREEN}[FIN] Instalacion completada correctamente.${NC}"
echo "Recuerda instalar manualmente las extensiones listadas en gnome/extensions-list.txt"
