#!/bin/bash

# --- 1. PREPARACIÓN ---
echo "Iniciando configuración de Dotfiles..."

# Asegurarse de estar en la carpeta correcta
cd ~/dotfiles

# Instalar dependencias básicas si no están
echo "Instalando git y stow..."
sudo pacman -S --needed git stow

# --- 2. ENLACES SIMBÓLICOS (STOW) ---
echo "Enlazando configuraciones..."
# Borra el .bashrc por defecto que crea Arch para evitar conflictos
rm -f ~/.bashrc 

# Ejecuta Stow para las carpetas que creamos
stow bash
stow git
# stow ssh (Descomenta si creaste la carpeta ssh, si no, déjalo así)

echo "Archivos enlazados."

# --- 3. RESTAURAR GNOME (DCONF) ---
echo "Restaurando configuración de GNOME..."

# Verificar si los archivos existen antes de intentar cargarlos
if [ -f "gnome/desktop-settings.dconf" ]; then
    dconf load /org/gnome/desktop/ < gnome/desktop-settings.dconf
fi

if [ -f "gnome/shell-settings.dconf" ]; then
    dconf load /org/gnome/shell/ < gnome/shell-settings.dconf
fi

if [ -f "gnome/mutter-settings.dconf" ]; then
    dconf load /org/gnome/mutter/ < gnome/mutter-settings.dconf
fi


echo "GNOME configurado."

# --- 4. RECORDATORIO DE EXTENSIONES ---
echo "Instalar estas extensiones :"
if [ -f "gnome/extensions-list.txt" ]; then
    cat gnome/extensions-list.txt
else
    echo "   (No se encontró lista de extensiones)"
fi

# --- 5. FIN ---
echo " reiniciar sesión para ver todos los cambios."
