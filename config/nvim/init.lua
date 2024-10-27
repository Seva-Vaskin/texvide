-- General settings
vim.opt.number = true
vim.opt.autoindent = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.mouse = 'a'
vim.opt.swapfile = false
vim.opt.shiftwidth = 2
vim.opt.whichwrap:append('<,>,h,l,[,]')

vim.opt.spell = true
vim.opt.spelllang = { 'en', 'ru' }

-- Vim plug
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug('lervag/vimtex') -- Vim
-- Plug('neoclide/coc.nvim', { ['branch'] = 'release' }) -- CocSnippets
Plug('SirVer/ultisnips') -- Snippets
Plug('907th/vim-auto-save') -- Auto save
vim.call('plug#end')


-- Function to check for backspace
-- local function check_backspace()
--   local col = vim.fn.col('.') - 1
--   return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
-- end

-- Mappings
-- vim.api.nvim_set_keymap('i', '<Tab>', [[coc#pum#visible() ? coc#pum#next(1) : v:lua.check_backspace() ? "\<Tab>" : coc#refresh()]], { noremap = true, silent = true, expr = true })
-- vim.api.nvim_set_keymap('i', '<S-Tab>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], { noremap = true, silent = true, expr = true })
-- vim.api.nvim_set_keymap('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], { noremap = true, silent = true, expr = true })

-- VimTeX configuration
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_progname = 'nvr'
vim.g.vimtex_quickfix_mode = 0
vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg'

-- Auto save configuration
vim.g.auto_save = 1

-- UltiSnips configuration
vim.g.UltiSnipsExpandTrigger = '<c-l>'
vim.g.UltiSnipsJumpForwardTrigger = '<c-j>'
vim.g.UltiSnipsJumpBackwardTrigger = '<c-k>'
vim.g.UltiSnipsSnippetDirectories = { os.getenv('HOME') .. '/.config/nvim/UltiSnips' }

vim.g.perl_host_prog = '/usr/bin/perl'
