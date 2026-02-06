# Dotfiles (Arch Linux + GNOME)

## 📂 Contenido
* **Bash:** Configuración (`.bashrc`) con alias de navegación, colores y manejo de historial.
* **Git:** Identidad global (`.gitconfig`).
* **GNOME:**
  * Configuración de Escritorio, Interfaz y Comportamiento de Ventanas (Mutter).
  * Configuración del Dock (Shell).
  * Respaldo de preferencias de GNOME Console (`kgx`).
  * Lista de extensiones habilitadas.

## Instalación

1. **Clonar el repo**

   ```bash
   sudo pacman -S --needed git base-devel
   git clone https://github.com/agmonetti/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   chmod +x setup.sh
   ./setup.sh
   ```

---

## Detalles:
 - **Iconos**:We10X-special
 - **GRUB**: 
   - nano /etc/default/grub
   - remplazar linea GRUB_THEME="../.../.../theme.txt"




## Mas adelante

* [ ] Implementar instalación automática de software en `setup.sh`:
* **Pacman:** VSCode, Telegram, VLC.
* **AUR (Yay):** Google Chrome, Stremio, Docker Desktop.


> [!NOTE]
> Crear manualmente el archivo `~/.bash_secrets` y agregar ahí los alias de GCP y tokens:
>
> ```bash
> touch ~/.bash_secrets
> nano ~/.bash_secrets
> ```
