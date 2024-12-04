-- VimTeX configuration
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_view_zathura_options = os.getenv('HOST_OS') == 'Darwin' and '--mode fullscreen' or ''
vim.g.vimtex_compiler_progname = 'nvr'
vim.g.vimtex_quickfix_mode = 0
vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg'
vim.g.vimtex_complete_enabled = 1