-- Overview de workspaces (plugin Hyprspace, cargado por hyprpm).
-- Este módulo solo se carga cuando el plugin ya está presente: en el primer
-- parseo del config todavía no existe y hl.config() marcaría sus claves como
-- desconocidas. Hyprspace llama a reloadConfig() al registrarse, así que en el
-- segundo parseo hl.plugin.overview ya existe y esto sí se aplica.
hl.config({
    plugin = {
        overview = {
            disableGestures    = 0, -- gesto de 3 dedos (default: 1 = deshabilitado)
            showEmptyWorkspace = 0, -- no mostrar workspaces vacíos intercalados
            showNewWorkspace   = 0, -- no agregar el workspace vacío final
            reverseSwipe       = 1, -- invertir el gesto por natural_scroll
            exitOnSwitch       = 1, -- cerrar el panel al cambiar de ws con click
            disableBlur        = 1, -- sin difuminado (evita la banda del mini panel)
            overrideAnimSpeed  = 12, -- duración de la animación (décimas de s; 0 = usar la de Hyprland)
            affectStrut        = 0, -- no desplazar ventanas (mantiene las previews parejas)
            panelColor           = "rgba(0, 0, 0, 0.55)",
        },
    },
})

-- Atajo alternative al gesto, útil para probar el plugin sin touchpad.
hl.bind("SUPER + O", function()
    hl.plugin.overview.toggle()
end)