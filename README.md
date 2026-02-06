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
   git clone https://github.com/agmonetti/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Ejecutar el script de instalación**

   ```bash
   ./setup.sh
   ```

---

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
