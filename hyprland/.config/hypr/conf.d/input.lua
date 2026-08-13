-- Teclado, touchpad y gestos.
hl.config({
    input = {
        kb_layout = "latam",
        touchpad  = {
            natural_scroll = true,
        },
    },
    gestures = {
        workspace_swipe_distance = 800,
    },
})

-- Gestos de escritorio: 3 dedos horizontal para cambiar workspace.
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
