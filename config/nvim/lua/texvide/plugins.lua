-- Vim plug
local Plug = vim.fn['plug#']
vim.call('plug#begin')
    Plug('lervag/vimtex') -- Vim
    Plug('SirVer/ultisnips') -- Snippets
    Plug('907th/vim-auto-save') -- Auto save
    Plug('preservim/nerdtree') -- Nerdtree
    Plug('ryanoasis/vim-devicons') -- Icons
    Plug('catppuccin/nvim', { ['as'] = 'catppuccin' }) -- theme
vim.call('plug#end')
