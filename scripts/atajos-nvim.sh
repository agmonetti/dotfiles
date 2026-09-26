#!/usr/bin/env bash
set -euo pipefail

TMPFILE=$(mktemp /tmp/nvim-cheat-XXXXXX.sh)

cat > "$TMPFILE" << 'DISPLAY'
#!/usr/bin/env bash

visual_length() {
    local str="$1"
    str="${str//á/a}"; str="${str//é/e}"; str="${str//í/i}"
    str="${str//ó/o}"; str="${str//ú/u}"; str="${str//ñ/n}"
    str="${str//Á/A}"; str="${str//É/E}"; str="${str//Í/I}"
    str="${str//Ó/O}"; str="${str//Ú/U}"; str="${str//Ñ/N}"
    str="${str//━/-}"
    echo "${#str}"
}

pad_string() {
    local str="$1"
    local target="$2"
    local vlen=$(visual_length "$str")
    local spaces=$(( target - vlen ))
    if (( spaces > 0 )); then
        printf "%s%${spaces}s" "$str" ""
    else
        printf "%s" "$str"
    fi
}

format_cell() {
    local str="$1"
    if [[ "$str" == *"|"* ]]; then
        local key="${str%%|*}"
        local desc="${str#*|}"
        printf "%s %s" "$(pad_string "$key" 22)" "$(pad_string "$desc" 41)"
    else
        pad_string "$str" 64
    fi
}

c1=(
    "━━━━ MODOS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    "<leader> = Espacio|Tecla líder de LazyVim"
    "Esc|Volver a Modo Normal (siempre)"
    "i|Modo Insertar: escribir texto"
    "a|Insertar texto tras el cursor"
    "v / V|Visual: chars / líneas completas"
    ":|Modo Línea de Comandos"
    ""
    "━━━━ MOVIMIENTO ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    "h / j / k / l|Izq / Abajo / Arriba / Der"
    "Flechas|Moverse en cualquier modo"
    "w / b|Siguiente / anterior palabra"
    "0 / \$|Inicio / fin de línea"
    "gg / G|Primera / última línea"
    "{ / }|Saltar párrafo arriba / abajo"
    "Ctrl+d / Ctrl+u|Media pantalla abajo / arriba"
    ""
    "━━━━ GUARDAR Y SALIR ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    ":w|Guardar archivo actual"
    ":q|Cerrar archivo o ventana"
    ":wq  o  ZZ|Guardar y salir"
    ":q!  o  ZQ|Salir SIN guardar cambios"
    "<leader>qq|Salir completamente de Neovim"
    ""
    "━━━━ BUSCAR EN ARCHIVO ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    "/texto|Buscar hacia adelante"
    "?texto|Buscar hacia atrás"
    "n / N|Siguiente / anterior resultado"
    ":noh|Limpiar resaltado de búsqueda"
)

c2=(
    "━━━━ EDICIÓN Y ACCIONES ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    "u / Ctrl+r|Deshacer / Rehacer"
    "x|Borrar carácter bajo cursor"
    "dd|Cortar / eliminar línea"
    "yy|Copiar línea (yank)"
    "p / P|Pegar después / antes"
    "o / O|Nueva línea abajo / arriba"
    'ci"  o  ci(|Cambiar dentro de "" o ()'
    "r|Reemplazar un solo carácter"
    "K|Docs de función (LSP hover)"
    "gd|Ir a la definición (LSP)"
    "[d / ]d|Error anterior / siguiente"
    ""
    "━━━━ TUS AGREGADOS ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    "y / d|Copia / corta al portapapeles del sistema"
    "Alt+h / Alt+l|Mover pestaña izq / der"
    "[b / ]b|Ir a pestaña anterior / siguiente"
    "<leader>bd|Cerrar pestaña actual"
    "<leader>e|Abrir / cerrar árbol NvimTree"
    "NvimTree: a / d / r|Crear / eliminar / renombrar"
    ":MarkdownPreview|Vista previa Markdown en navegador"
    "Render-Markdown|Markdown formateado en buffer"
    "Wrap + Linebreak|Líneas largas sin corte abrupto"
    "Undofile|Deshacer persiste al reabrir"
    "Smartcase|Búsqueda inteligente activa"
    "Tema OneDark darker|Tema oscuro activo"
    ""
    "━━━━ LAZYVIM ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    "<leader><space>|Buscar archivo en el proyecto"
    "<leader>/|Live Grep (buscar texto global)"
    "<leader>ft / Ctrl+/|Abrir / cerrar terminal flotante"
    "<leader>cf|Formatear archivo (LSP)"
    "<leader>cm|Abrir Mason (LSP / linters)"
    "<leader>l|Abrir Lazy (gestión de plugins)"
)

while [ ${#c1[@]} -lt ${#c2[@]} ]; do
    c1+=("")
done
while [ ${#c2[@]} -lt ${#c1[@]} ]; do
    c2+=("")
done

echo ""
echo "  NEOVIM · ATAJOS DE TECLADO Y CONFIGURACIONES"
echo ""

for ((i=0; i<${#c1[@]}; i++)); do
    printf "    "
    format_cell "${c1[i]:-}"
    printf "    "
    format_cell "${c2[i]:-}"
    printf "\n"
done

DISPLAY

kitty \
    --hold \
    --class atajos-nvim \
    --title "Neovim · Atajos de Teclado" \
    --override font_size=11 \
    --override scrollbar_min_height=0 \
    bash "$TMPFILE"

rm -f "$TMPFILE"
