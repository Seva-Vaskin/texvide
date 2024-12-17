-- UltiSnips configuration
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
vim.g.UltiSnipsJumpBackwardTrigger = '<S-tab>'
vim.g.UltiSnipsSnippetDirectories = { os.getenv('HOME') .. '/.config/nvim/ultisnips' }
vim.g.maxmempattern = 2000

-- vim.api.nvim_set_keymap('i', '<c-ы>', '<cmd>call UltiSnips#ExpandSnippet()<CR>', { noremap = true, silent = true })
