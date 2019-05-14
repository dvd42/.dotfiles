" *** Inspited by https://github.com/prlz77/nvim *** 

set nocompatible
filetype off

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.config/env_setup/nvim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tmhedberg/SimpylFold'
Plug 'joshdick/onedark.vim'
Plug 'neomake/neomake'
Plug 'python-mode/python-mode', {'branch':'develop'}
Plug 'tpope/vim-fugitive'
Plug 'kien/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()


" *** Tmux Navigator *** 
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 2

" *** crtlp.vim ***
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=__pycache__/*
set wildignore+=.git/*

" *** Tmux-Navigator ***
let g:tmux_navigator_save_on_switch = 2
"
" *** Pymode ***
let g:pymode_python = 'python3'
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_trim_whitespaces = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax = 1
let g:pymode_syntax_space_errors = 0
let g:pymode_rope_completion = 1
let g:pymode_rope = 1
let g:pymode_breakpoint = 0
let g:pymode_syntax_builtin_objs = 1
let g:pymode_syntax_builtin_funcs = 1
let g:pymode_lint_unmodified = 1
let g:pymode_lint_on_write = 1
let g:pymode_rope_lookup_project = 1

" *** Airline ***
let g:airline#extensions#tabline#enabled = 1 
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1

