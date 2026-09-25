-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.spell = false
-- Portapapeles del sistema: copiar (y) o cortar (d) va directo a Ctrl+V fuera de Neovim
vim.opt.clipboard = "unnamedplus"

-- Envoltura de líneas: que no corte palabras largas a mitad de camino al hacer wrap
vim.opt.wrap = true
vim.opt.linebreak = true

-- Búsqueda inteligente: ignora mayúsculas salvo que escribas una explícitamente
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Margen de scroll: mantiene 8 líneas visibles arriba/abajo al desplazarte
vim.opt.scrolloff = 8

-- Suavizar redraw al ejecutar macros o scripts
vim.opt.lazyredraw = true

-- Historial de deshacer persistente entre cierres de Neovim
vim.opt.undofile = true
