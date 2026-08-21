-- Variables de entorno y programas en autostart.
-- Equivalente a: env = GTK_THEME,Adwaita:dark  y  exec-once = ...
hl.env("GTK_THEME", "Adwaita:dark")

local home     = os.getenv("HOME")
local dotfiles = os.getenv("DOTFILES_DIR") or home .. "/dotfiles"

hl.on("hyprland.start", function()
    hl.exec_cmd("mako")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd(dotfiles .. "/scripts/restore_wall.sh")
    hl.exec_cmd(dotfiles .. "/scripts/battery-notify.sh")
    hl.exec_cmd("hypridle")
end)
