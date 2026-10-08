local tree_width = 30

return {
  {
    "nvim-tree/nvim-tree.lua",
    event = "VimEnter",
    init = function()
      -- Guarda el ancho antes de salir del árbol, para conservar ajustes al abrir archivos.
      vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        callback = function()
          if vim.bo.filetype == "NvimTree" then
            tree_width = vim.api.nvim_win_get_width(0)
          end
        end,
      })

      -- Desactiva netrw al inicio (recomendado por NvimTree)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          vim.schedule(function()
            require("nvim-tree.api").tree.open()
          end)
        end,
      })
    end,
    opts = {
      view = {
        width = function()
          return tree_width
        end,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true, -- En false para ver carpetas y archivos ocultos (.config, .git, etc.)
        git_ignored = false, -- Muestra también archivos ignorados por .gitignore.
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Mantiene todos los atajos por defecto de NvimTree
        api.config.mappings.default_on_attach(bufnr)

        -- Shift + C: fija la carpeta bajo el cursor como raíz del árbol y de Neovim
        vim.keymap.set("n", "C", function()
          local node = api.tree.get_node_under_cursor()
          if node then
            local path = node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
            vim.fn.chdir(path)
            api.tree.change_root(path)
          end
        end, {
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
          desc = "CD: Fijar carpeta como raíz",
        })
      end,
    },
    keys = {
      -- Abrir o cerrar el árbol con Espacio + e
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    },
  },
}
