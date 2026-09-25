return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- Desactiva netrw al inicio (recomendado en la documentación)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true, -- Ponlo en true si prefieres ocultar archivos ocultos
      },
    },
    keys = {
      -- Atajo de teclado: presiona <Espacio> + e para abrir/cerrar el árbol
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
  },
}
