require('texvide.plugins')

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n' ,'<c-y>', ':NERDTreeToggle<CR>', opts)

