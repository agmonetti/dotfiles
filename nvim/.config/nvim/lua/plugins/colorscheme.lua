return {
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- Carga el tema antes que el resto de plugins
    config = function()
      require("onedark").setup({
        style = "darker", -- Opciones: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
      })
      require("onedark").load()
    end,
  },
  -- Opcional: configurar LazyVim para que use este tema por defecto
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
