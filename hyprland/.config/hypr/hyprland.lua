-- Configuración principal de Hyprland (formato Lua, requerido desde 0.55).
-- El formato hyprlang (hyprland.conf) quedó deprecado en favor de Lua.
-- https://wiki.hypr.land/Configuring/Start/

-- La config se divide en módulos dentro de conf.d/ y se cargan con require().
-- Se usa ruta explícita "./conf.d/..." porque el nombre "conf.d" contiene un
-- punto (Lua lo interpretaría como separador de directorio) y Hyprland resuelve
-- las rutas explícitas relativas al directorio de configuración.
require("./conf.d/monitors")
require("./conf.d/input")
require("./conf.d/appearance")
require("./conf.d/binds")
require("./conf.d/autostart")
require("./conf.d/rules")
