require('texvide.config')
require('texvide.colorscheme')
require('texvide.keymaps')
require('texvide.plugins')
require('texvide.features')

require('texvide.plugin-settings.ultisnips')
require('texvide.plugin-settings.vimtex')
require('texvide.plugin-settings.inkscape_figures')
require('texvide.plugin-settings.nerdtree')
require('texvide.plugin-settings.startify')
require('texvide.plugin-settings.sakls')
-- require('texvide.plugin-settings.autopairs')

require('texvide.advanced-snippets.matrix_shortcuts')

-- Load user custom configuration if exists
local user_config = vim.fn.expand('~/.config/texvide/nvim/init.lua')
if vim.fn.filereadable(user_config) == 1 then
    dofile(user_config)
end