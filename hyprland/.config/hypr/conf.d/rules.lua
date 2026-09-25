-- Reglas de ventanas y workspaces.
-- La config base no necesita reglas; se agregan acá de forma modular.

hl.window_rule({
    name   = "float-yazi",
    match  = { class = "yazi" },
    float  = true,
    center = true,
    size   = { "(monitor_w*0.7)", "(monitor_h*0.75)" },
})
