require("nvfs-keymaps")

require 'lspconfig'.openscad_lsp.setup {
  cmd = { "@openscad-lsp@", "--stdio" }
}

local keyopts = { noremap = true, silent = true }
vim.keymap.set({ 'n', 'v', 'o' }, 'K',
  function() require('tree-climber').goto_parent({ highlight = true, timeout = 1000 }) end, keyopts)
vim.keymap.set({ 'n', 'v', 'o' }, 'J',
  function() require('tree-climber').goto_child({ highlight = true, timeout = 1000 }) end, keyopts)
vim.keymap.set({ 'n', 'v', 'o' }, 'L',
  function() require('tree-climber').goto_next({ highlight = true, timeout = 1000 }) end, keyopts)
vim.keymap.set({ 'n', 'v', 'o' }, 'H',
  function() require('tree-climber').goto_prev({ highlight = true, timeout = 1000 }) end, keyopts)
vim.keymap.set({ 'v', 'o' }, 'in', require('tree-climber').select_node, keyopts)
vim.keymap.set('n', '<c-h>', require('tree-climber').swap_prev, keyopts)
vim.keymap.set('n', '<c-l>', require('tree-climber').swap_next, keyopts)
