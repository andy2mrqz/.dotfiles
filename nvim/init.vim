" Plugins
call plug#begin()
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-surround'
Plug 'machakann/vim-highlightedyank'
Plug 'lewis6991/gitsigns.nvim' " Migrate to packer
call plug#end()

" Colorscheme
syntax on
colorscheme codedark
highlight TabLineSel ctermbg=30

" Utility
set autochdir
set hidden " switch buffers without saving
set updatetime=250
set mouse=a
set showtabline=2

" Visual effects
highlight MatchParen cterm=underline ctermbg=green ctermfg=blue
set number
" set relativenumber
set cursorline
set grepprg=rg\ --vimgrep
set foldmethod=manual
set tabstop=2 " tab width
set shiftwidth=2
set expandtab

" Python provider options
let g:python3_host_prog = '/usr/local/bin/python3'
let g:loaded_python_provider = 0 " Disable python 2 support

