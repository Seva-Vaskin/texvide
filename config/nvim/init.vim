" Show line numbers
set number
set relativenumber

set mouse=a

set clipboard=unnamedplus

" for clipboard proper working
xnoremap "+y y:call system("wl-copy", @")<cr>
nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p

set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set autoindent
set smartindent

set noswapfile

set cursorline " Highlight current line

" Go to previous line when press left arrow on 1st character
set ww+=<,>,[,]

nnoremap <SPACE> <Nop>
let mapleader=" "

call plug#begin()

Plug 'vim-airline/vim-airline'								 " Status bar
Plug 'vim-airline/vim-airline-themes'                        " Schemes for status bar
Plug 'preservim/nerdtree'				                     " NerdTree
Plug 'jistr/vim-nerdtree-tabs'			                     " NerdTree tabs
Plug 'ryanoasis/vim-devicons'                                " Developer Icons
Plug 'tpope/vim-commentary'				                     " For Commenting gcc & gc
Plug 'jiangmiao/auto-pairs'				                     " Auto pairs
Plug 'lervag/vimtex'										 " Tex support
Plug 'https://gitlab.com/code-stats/code-stats-vim.git'      " Code stats
Plug 'mhinz/vim-startify'                                    " Workspaces setup plugin
Plug 'bfrg/vim-cpp-modern'									 " C/C++ code highlight
Plug 'udalov/kotlin-vim'									 " Kotlin syntax highlight
Plug '907th/vim-auto-save'									 " Auto save
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}              " Auto completion engine
Plug 'tpope/vim-fugitive'									 " Git wrapper
Plug 'airblade/vim-gitgutter'								 " Shows git diff lines
Plug 'easymotion/vim-easymotion'                             " Motions
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-autoformat/vim-autoformat'						 " Autoformat
Plug 'chrisbra/Colorizer'
Plug 'lambdalisue/suda.vim'                                  " Reopen with sudo
Plug 'github/copilot.vim'                                    " github copilot
Plug 'SirVer/ultisnips'									     " Snippets

Plug 'navarasu/onedark.nvim'                                 " Colorscheme
call plug#end()

set background=light
colorscheme onedark 

set updatetime=600

nnoremap <C-t> :NERDTreeToggle %<CR>

" Comment line with Ctrl + /
nnoremap <C-_> :Commentary<CR> j :left<CR>
inoremap <C-_> <esc> :Commentary<CR> j a

" Confirm on Enter
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" TODO TODO TODO
" change to ctrl + alt + b and remove others
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Tab switches
nnoremap <A-Left> :tabprevious<CR>
nnoremap <A-Right> :tabnext<CR>
nnoremap <C-n> :tabnew<CR>
nnoremap <C-F4> :tabclose<CR>    " TODO TODO TODO Not working


" Set completeopt to have a better completion experience
set completeopt=menuone,longest,noinsert,noselect

" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

set cc=120 " set an 80 column border for good coding style

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" VimTeX configure
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

let g:auto_save = 0  " enable AutoSave on Vim startup

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-s>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Code stas setup
let g:codestats_api_key = 'SFMyNTY.WW5WNWIyeHBkSE5sZWc9PSMjTVRZek5UQT0.HvfE0f56zYbQMHKM8HWAT_rzgAyyJFnCiagsqrogWRM'

" Optional: configure vim-airline to display status
let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype', '%{CodeStatsXp()}'])

" Autoformat
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

" Workspaces setup
let g:startify_session_dir = '~/.config/nvim/session'
let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 1

" Copy line on <Ctrl + d>
" inoremap <C-d> <Esc>yypi
" nnoremap <C-d> yyp

" Inkscape figures
inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

" Set to auto read when a file is changed from the outside
set autoread

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Show matching brackets when text indicator is over them
set showmatch

" Case insensitive on search
set ignorecase

" Read modelines at the end and begging
set modeline

set spell
set spelllang=en,ru

" Vim insert delete over line breaks, or automatically-inserted indentation
set backspace=indent,eol,start

" Better wrapping
set breakindent
set showbreak=\\\\\

" Return to last edit position when opening files
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal! g`\"" |
			\ endif

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Automatically close NerdTree when you open a file
let NERDTreeQuitOnOpen = 1

" Automatically delete the buffer of the file you just deleted with NerdTree:
let NERDTreeAutoDeleteBuffer = 1

" Highlight changed lines since last save
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

source ~/.config/nvim/plugconfig/easy-motion.vim

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
