-- Monitores.
-- Equivalente a: monitor=,preferred,auto,1.2
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1.2",
})

-- Al recargar la config (ej: cambio de monitores), recalcular el color
-- adaptativo del contenido de Waybar.
local home     = os.getenv("HOME")
local dotfiles = os.getenv("DOTFILES_DIR") or home .. "/dotfiles"
hl.on("config.reloaded", function()
    hl.exec_cmd(dotfiles .. "/scripts/waybar-adaptive.sh")
end)
