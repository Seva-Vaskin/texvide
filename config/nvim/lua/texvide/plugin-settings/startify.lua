vim.g.startify_custom_header = {
  '  _______      __      _______ _____  ______ ',
  ' |__   __|     \\ \\    / /_   _|  __ \\|  ____|',
  '    | | _____  _\\ \\  / /  | | | |  | | |__   ',
  '    | |/ _ \\ \\/ /\\ \\/ /   | | | |  | |  __|  ',
  '    | |  __/>  <  \\  /   _| |_| |__| | |____ ',
  '    |_|\\___/_/\\_\\  \\/   |_____|_____/|______|',
  '                                             ',
  '                                             '
}

-- Function to enhance Startify navigation
vim.cmd([[
  augroup StartifyCustom
    autocmd!
    " Open NERDTree when selecting a file
    autocmd User Startified silent! execute 'NERDTree'
  augroup END
]])

