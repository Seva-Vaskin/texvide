-- General settings
vim.opt.number = true
vim.opt.autoindent = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.mouse = 'a'
vim.opt.swapfile = false
vim.opt.shiftwidth = 4
vim.opt.whichwrap:append('<,>,h,l,[,]')

vim.opt.spell = true
vim.opt.spelllang = { 'en', 'ru' }


vim.g.auto_save = 1
vim.g.perl_host_prog = '/usr/bin/perl'

-- Enable smart case (case-sensitive if uppercase letters are used in the search)
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Ensure Neovim leaves some lines at the top and bottom
vim.opt.scrolloff = 9

