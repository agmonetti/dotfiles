-- Atajos de teclado y mouse.
local mainMod     = "SUPER"
local terminal    = "kitty"
local menu        = "rofi -show drun"
local fileManager = "kitty --class yazi -e yazi"

local home     = os.getenv("HOME")
local dotfiles = os.getenv("DOTFILES_DIR") or home .. "/dotfiles"
local scripts  = dotfiles .. "/scripts"
local shotsDir = os.getenv("SCREENSHOTS_DIR") or home .. "/Pictures/Screenshots"

-- Aplicaciones y lanzadores
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind("CTRL + SPACE",    hl.dsp.exec_cmd(menu))
hl.bind("SUPER + tab",     hl.dsp.exec_cmd("rofi -show window"))

-- Gestión de ventanas
hl.bind(mainMod .. " + C",    hl.dsp.window.close())
hl.bind(mainMod .. " + V",    hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + up",   hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + M",    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))

-- Arrastrar / redimensionar ventanas con el mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces: SUPER + [0-9] para enfocar, SUPER + SHIFT + [0-9] para mover
hl.bind("SUPER + D", hl.dsp.focus({ workspace = "empty" }))
for i = 1, 10 do
    local key = i % 10 -- 10 se mapea a la tecla 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    if i <= 5 then
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end
end

-- Cambiar fondo de pantalla con rofi / Alternar color de Waybar manualmente
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd(scripts .. "/cambiar_fondo.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(scripts .. "/waybar-adaptive.sh toggle"))

-- Capturas de pantalla
hl.bind("Print",         hl.dsp.exec_cmd("hyprshot -m region -o " .. shotsDir))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m output -o " .. shotsDir))

-- Modos de energía
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("powerprofilesctl set balanced && notify-send -a \"Sistema\" \"Modo de Energía\" \"Perfil: Balanceado 󰾆\""))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("powerprofilesctl set performance && notify-send -a \"Sistema\" \"Modo de Energía\" \"Perfil: Rendimiento 󰓅\""))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("powerprofilesctl set power-saver && notify-send -a \"Sistema\" \"Modo de Energía\" \"Perfil: Ahorro de Batería 󰎆\""))

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(scripts .. "/vol-toggle.zsh"), { locked = true })

-- Brillo
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })
