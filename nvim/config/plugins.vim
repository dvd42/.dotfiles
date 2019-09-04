" *** Inspited by https://github.com/prlz77/nvim *** 

set nocompatible
filetype off

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.config/env_setup/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kamykn/spelunker.vim'
Plug 'zchee/deoplete-jedi'
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
Plug 'kkoomen/vim-doge'
Plug 'tpope/vim-commentary'
call plug#end()


" *** Tmux Navigator *** 
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 1

" *** crtlp.vim ***
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=__pycache__/*
set wildignore+=.git/*
set wildignore+=*.jpg
set wildignore+=*.png
set wildignore+=*.jpeg

" *** Tmux-Navigator ***
let g:tmux_navigator_save_on_switch = 2
"
" *** Pymode ***
let g:pymode_python = 'python3'
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_rope_lookup_project = 1
let g:pymode_rope = 1
let g:pymode_breakpoint = 0
let g:pymode_syntax_space_errors = 0
let g:pymode_lint_on_write = 0
let g:pymode_rope_completion = 0

" *** Deoplete *** 
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = expand("~/.pyenv/versions/neovim3/bin/python")
let g:deoplete#auto_complete=1
let g:deoplete#sources#jedi#enable_typeinfo = 0 "gotta go fast
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif "automatically closing the scratch window at the top of the vim window on finishing a complete or leaving insert

" *** Airline ***
let g:airline#extensions#tabline#enabled = 1 
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1

" *** Spelunker ***
let g:spelunker_check_type = 2
set updatetime=1000

" *** DoGe ***
let g:doge_doc_standard_python = 'google'
let g:doge_mapping_comment_jump_forward = '<leader><tab>'
let g:doge_mapping_comment_jump_backward = '<leader><s-tab>'
