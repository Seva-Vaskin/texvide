-- UltiSnips configuration
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<c-j>'
vim.g.UltiSnipsJumpBackwardTrigger = '<c-k>'
vim.g.UltiSnipsSnippetDirectories = { os.getenv('HOME') .. '/.config/nvim/ultisnips' }
vim.g.maxmempattern = 2000
