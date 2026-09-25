# ~/.config/nvim/lua/plugins/no-inlay-hints.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
  },
}
