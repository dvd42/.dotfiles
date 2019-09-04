" *** Inspited by https://github.com/prlz77/nvim *** 

set nocompatible
filetype off

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.config/env_setup/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "completion
Plug 'kamykn/spelunker.vim' "spell check
Plug 'zchee/deoplete-jedi' "completion
Plug 'joshdick/onedark.vim' "colortheme
Plug 'vim-airline/vim-airline' "airline bar
Plug 'tmhedberg/SimpylFold' "easy fold
Plug 'neomake/neomake' "multithreading
Plug 'python-mode/python-mode', {'branch':'develop'} "project-like behaviour for python
Plug 'tpope/vim-fugitive' "git functionality
Plug 'kien/ctrlp.vim' "search for files
Plug 'christoomey/vim-tmux-navigator' "tmux integration
Plug 'kshenoy/vim-signature' "easy marks
Plug 'kkoomen/vim-doge' "generate docstring
Plug 'tpope/vim-commentary' "easy comment lines
Plug 'takac/vim-hardtime' "remove bad habits
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

" *** HardTime ***
let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "-", "+"]
let g:list_of_visual_keys = ["h", "j", "k", "l", "-", "+"]
let g:list_of_insert_keys = ["h", "j", "k", "l", "-", "+"]
let g:hardtime_timeout = 2000
let g:hardtime_showmsg = 1
let g:hardtime_allow_different_key = 1
