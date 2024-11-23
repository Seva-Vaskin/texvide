-- Insert mode mapping for creating figures with Inkscape
vim.api.nvim_set_keymap(
  "i",
  "<C-f>",
  [[<Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>]],
  { noremap = true, silent = true }
)

-- Normal mode mapping for editing figures with Inkscape
vim.api.nvim_set_keymap(
  "n",
  "<C-f>",
  [[ : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>]],
  { noremap = true, silent = true }
)
