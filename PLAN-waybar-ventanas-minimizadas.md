# Plan: indicador Waybar para ventanas enviadas al fondo

## Objetivo

Al usar `SUPER+B` en un workspace, mostrar en Waybar un icono de la aplicación minimizada **solo mientras ese workspace esté activo**. Ejemplo: minimizar en el workspace 1 muestra allí el icono; al cambiar al 2 desaparece y reaparece al volver al 1.

El icono irá inmediatamente a la derecha de la hora (`clock#time`). No se mostrará el número del workspace ni se agregará una acción al hacer clic.

## Comportamiento actual

`hyprland/.config/hypr/conf.d/binds.lua` etiqueta la ventana activa como `minimized` y la mueve al workspace especial `special:minimized`. El workspace de origen no se conserva explícitamente.

Además, la rama actual de `SUPER+B` decide si minimiza o restaura según exista `special:minimized`; hay que verificar el comportamiento con más de una ventana antes de modificarlo, para no cambiar inadvertidamente el atajo.

Waybar está configurada en `waybar/.config/waybar/config.jsonc`; `clock#time` está en `modules-left`.

## Implementación propuesta

### Decisión

Usar tags de Hyprland, sin archivo de estado adicional. Antes de cambiar archivos, comprobar en la API Lua disponible que se pueda leer el workspace de la ventana activa, asignar y consultar tags, y obtener las ventanas minimizadas con sus clases. Si alguna operación no está soportada, detenerse y revisar esta decisión antes de introducir otro mecanismo de estado.

### Cambios

1. **Validar las operaciones de Hyprland.** Revisar la API de `hl` que carga esta configuración y confirmar cómo obtener el workspace de la ventana activa y cómo leer ventanas, clases y tags. Hacer esta comprobación antes de editar `binds.lua`; no asumir que existe una operación solo porque los tags de ventana ya se usan.
2. **Registrar el origen al minimizar.** En `hyprland/.config/hypr/conf.d/binds.lua`, conservar el flujo actual de `SUPER+B`: antes de mover la ventana activa a `special:minimized`, añadirle un tag propio con el identificador del workspace de origen, además del tag `minimized`. No borrar tags ajenos.
3. **Restaurar sin perder el comportamiento actual.** Al restaurar, mover las ventanas con tag `minimized` al workspace guardado en su tag de origen y retirar únicamente los tags que añadió este mecanismo. Primero verificar y describir el comportamiento existente del atajo con varias ventanas; mantener la semántica actual si es posible y no ampliarla por accidente.
4. **Añadir el módulo de Waybar.** En `waybar/.config/waybar/config.jsonc`, insertar `custom/minimized` justo después de `clock#time` en `modules-left`. Configurarlo para ejecutar un script existente o nuevo que consulte el estado de Hyprland, filtre las ventanas minimizadas por workspace activo y emita los glifos correspondientes. No imprimir nada si no hay coincidencias. No añadir dependencias.
5. **Refrescar la salida.** Preferir el mecanismo nativo de Waybar para actualizar el módulo al cambiar de workspace y al minimizar/restaurar. Si no permite cubrir ambos eventos de forma fiable, usar sondeo con un intervalo razonable; no crear un daemon adicional.
6. **Mapear iconos con fallback.** Usar la clase de ventana para una tabla pequeña de glifos en el script. Para clases desconocidas, emitir un glifo genérico no vacío. No mostrar nombres, contadores, tooltip ni acciones.

### Orden de trabajo y archivos previstos

1. Confirmar capacidades de la API Lua y del módulo `custom` de Waybar.
2. Modificar `hyprland/.config/hypr/conf.d/binds.lua` para registrar origen y restaurar.
3. Añadir el script mínimo de consulta/renderizado en `scripts/`.
4. Modificar `waybar/.config/waybar/config.jsonc` para colocar y configurar el módulo.
5. Validar sintaxis de los archivos y recargar Hyprland/Waybar; corregir antes de darlo por terminado.

No tocar otros archivos locales fuera de estos cambios ni sobrescribir cambios preexistentes. Si la validación inicial no confirma la API necesaria, no continuar con una implementación especulativa: actualizar primero este plan con la alternativa de estado acordada.

## Estado de ejecución

- **Implementado:** tags de origen en `SUPER+B`, script `scripts/minimized_windows.py` y módulo `custom/minimized` junto a la hora.
- **Validado:** API de ventanas/tags en los stubs de Hyprland instalado; recarga de Hyprland sin errores; configuración de Waybar aceptada al iniciar y recargar; prueba del script para workspace coincidente, distinto y clase sin mapeo.
- **Pendiente de comprobación visual:** probar minimización/restauración real con una y varias ventanas en workspaces distintos y confirmar los glifos en la barra.
- La restauración ahora devuelve cada ventana al workspace de origen registrado. La versión previa movía todas las ventanas minimizadas al workspace activo; esta diferencia es intencional para que la relación ventana-workspace se mantenga al restaurar.

## Alcance

- Incluir la asociación ventana minimizada → workspace de origen y la visualización condicionada al workspace activo.
- Mantener la posición junto a la hora.
- No mostrar etiqueta de workspace, nombre de aplicación, contador, tooltip ni menú.
- No cambiar el mecanismo de minimizado/restauración más de lo estrictamente necesario para registrar el workspace y refrescar Waybar.
- No tocar los cambios locales preexistentes en otros archivos.

## Dificultad estimada

**Baja a moderada.** La integración visual de Waybar es pequeña. La parte que requiere validación es conservar/leer el workspace de origen desde el flujo Hyprland Lua actual y refrescar el módulo de forma fiable. La correspondencia de clases de aplicación a glifos necesita un fallback, pero no una dependencia adicional.

## Verificación antes de darlo por terminado

- Minimizar una aplicación en el workspace 1: su icono aparece junto a la hora en el 1.
- Cambiar al workspace 2: el icono no aparece.
- Volver al 1: el icono aparece de nuevo.
- Minimizar aplicaciones en dos workspaces: cada icono aparece solo en su workspace de origen.
- Restaurar una ventana: su icono desaparece.
- Probar el atajo con más de una ventana minimizada para comprobar que la lógica actual de `SUPER+B` sigue siendo coherente.
- Comprobar una clase de aplicación sin mapeo y verificar que el fallback no deja el módulo vacío ni rompe Waybar.

## Fuera de alcance

No se implementa aquí. La implementación empieza solo después de revisar y aprobar este plan.
