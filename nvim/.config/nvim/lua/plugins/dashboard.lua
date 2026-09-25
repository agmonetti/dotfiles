return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          -- Lista de botones personalizados: cambia atajos, nombres o acciones
          keys = {
            { icon = " ", key = "f", desc = "Buscar archivo", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "g", desc = "Buscar texto", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = " ",
              key = "r",
              desc = "Archivos recientes",
              action = ":lua Snacks.dashboard.pick('oldfiles')",
            },
            { icon = " ", key = "n", desc = "Nuevo archivo", action = ":ene | startinsert" },
            {
              icon = " ",
              key = "c",
              desc = "Configuración",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = "󰒲 ", key = "l", desc = "Lazy plugins", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Salir", action = ":qa" },
          },
        },
        sections = {
          -- Quitando { section = "header" } desaparece cualquier logo de arriba
          { section = "keys", gap = 1, padding = 2 },
          { section = "startup" },
        },
      },
    },
  },
}
