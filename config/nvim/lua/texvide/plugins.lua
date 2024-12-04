-- Vim plug
local Plug = vim.fn['plug#']
vim.call('plug#begin')
    Plug('lervag/vimtex') -- Vim
    Plug('SirVer/ultisnips') -- Snippets
    Plug('907th/vim-auto-save') -- Auto save
    Plug('preservim/nerdtree') -- Nerdtree
    Plug('ryanoasis/vim-devicons') -- Icons
    Plug('catppuccin/nvim', { ['as'] = 'catppuccin' }) -- theme
	Plug('mhinz/vim-startify') -- Start screen
	Plug('tpope/vim-fugitive') -- Git wrapper
	Plug('airblade/vim-gitgutter') -- Shows git diff lines
    Plug('sharkov63/sakls.nvim') -- Syntax-Aware Keyboard Layout Switching 
    Plug('windwp/nvim-autopairs') -- Automaticall match braces
vim.call('plug#end')
