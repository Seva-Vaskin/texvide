local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

-- Window movement
keymap('n', '<c-j>', '<c-w>j', opts)
keymap('n', '<c-h>', '<c-w>h', opts)
keymap('n', '<c-k>', '<c-w>k', opts)
keymap('n', '<c-l>', '<c-w>l', opts)
-- Undo
keymap('n', '<C-z>', 'u', opts)
keymap('v', '<C-z>', 'u', opts)
keymap('i', '<C-z>', '<C-o>u', opts)
-- Redo
keymap('n', '<C-S-z>', '<C-r>', opts)
keymap('v', '<C-S-z>', '<C-r>', opts)
keymap('i', '<C-S-z>', '<C-o><C-r>', opts)
-- Quit
keymap('n', '<C-q>', ':q<CR>', opts)
keymap('v', '<C-q>', ':q<CR>', opts)
keymap('i', '<C-q>', '<C-o>:q<CR>', opts)
-- Copy
keymap('v', '<C-c>', '"+y', opts)
-- Paste
keymap('n', '<C-v>', '"+p', opts)
keymap('v', '<C-v>', '"+p', opts)
keymap('i', '<C-v>', '<C-r>+', opts)