-- UltiSnips configuration
vim.g.UltiSnipsExpandTrigger = '<c-l>'
vim.g.UltiSnipsJumpForwardTrigger = '<c-j>'
vim.g.UltiSnipsJumpBackwardTrigger = '<c-k>'
vim.g.UltiSnipsSnippetDirectories = { os.getenv('HOME') .. '/.config/nvim/ultisnips' }