" *** Inspited by https://github.com/prlz77/nvim *** 

set nocompatible
filetype off

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.config/env_setup/nvim/plugged')
Plug 'Valloric/YouCompleteMe'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'tmhedberg/SimpylFold'
Plug 'joshdick/onedark.vim'
Plug 'neomake/neomake'
Plug 'python-mode/python-mode', {'branch':'develop'}
Plug 'tpope/vim-fugitive'
Plug 'kien/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kshenoy/vim-signature'
call plug#end()


" *** Tmux Navigator *** 
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 1

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
let g:pymode_rope_lookup_project = 1
let g:pymode_breakpoint = 0
let g:pymode_syntax_space_errors = 0
let g:pymode_lint_on_write = 0
set completeopt=menuone,noinsert

"Correct lint errors
command! Lint execute "PymodeLintAuto "
"
"Check lint errors
command! Check execute "PymodeLint"

"Initialize ropeproject on current dir
command! -complete=file -nargs=+ Init call InitProject(<f-args>)


" *** Airline ***
let g:airline#extensions#tabline#enabled = 1 
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1
