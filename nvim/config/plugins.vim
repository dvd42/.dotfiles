" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.config/env_setup/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "completion
Plug 'kamykn/spelunker.vim' "spell check
Plug 'zchee/deoplete-jedi' "completion
Plug 'drewtempelmeyer/palenight.vim'
Plug 'vim-airline/vim-airline' "airline bar
Plug 'tmhedberg/SimpylFold' "easy fold
Plug 'neomake/neomake' "multithreading
Plug 'python-mode/python-mode', {'branch':'develop'} "project-like behaviour for python
Plug 'tpope/vim-fugitive' "git functionality
Plug 'albacoretuna/FlyGrep.vim', { 'branch': 'oldjanuary' }
Plug 'ctrlpvim/ctrlp.vim' "search for files
Plug 'christoomey/vim-tmux-navigator' "tmux integration
Plug 'kkoomen/vim-doge' "generate docstring
Plug 'tpope/vim-commentary' "easy comment lines
Plug 'takac/vim-hardtime' "remove bad habits
Plug 'ryanoasis/vim-devicons' "nice icons
Plug 'roxma/vim-tmux-clipboard' "solves clipboard headaches
Plug 'francoiscabrol/ranger.vim' "ranger for nvim
Plug 'rbgrouleff/bclose.vim' "ranger for nvim (autoclose buffer)
Plug 'vuciv/vim-bujo' "todo list
call plug#end()

let g:python3_host_prog = expand("~/.pyenv/versions/neovim/bin/python")

" *** Neomake ***
" When reading a buffer (after 1s), and when writing (no delay).
call neomake#configure#automake('nw', 500)
let g:neomake_open_list = 0

let g:neomake_python_pylint_maker = {
    \ 'exe': 'pylint',
    \ 'args': [
        \ '--output-format=text',
        \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} [{msg_id}]"',
        \ '--reports=no',
        \ '--extension-pkg-whitelist=cv2',
        \ '--generated-members=numpy.*,torch.*',
        \ '--disable=C0111, C0103, W0621',
        \ '--max-line-length=88',
        \ '--jobs=2'
    \ ],
    \ 'errorformat':
        \ '%A%f:%l:%c:%t: %m,' .
        \ '%A%f:%l: %m,' .
        \ '%A%f:(%l): %m,' .
        \ '%-Z%p^%.%#,' .
        \ '%-G%.%#',
    \ 'output_stream': 'stdout',
    \ 'postprocess': [
    \   function('neomake#postprocess#generic_length'),
    \   function('neomake#makers#ft#python#PylintEntryProcess'),
    \ ]}

let g:neomake_python_enabled_makers = ['pylint']


" *** Tmux Navigator ***
" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 1
let g:tmux_navigator_save_on_switch = 2

" *** crtlp.vim ***
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=__pycache__/*
set wildignore+=.git/*
set wildignore+=*.jpg
set wildignore+=*.png
set wildignore+=*.jpeg
set wildignore+=*.mp4

" *** Pymode ***
let g:pymode_python = 'python3'
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_rope_lookup_project = 1
let g:pymode_rope = 1
let g:pymode_options = 0
let g:pymode_breakpoint = 0
let g:pymode_syntax_space_errors = 0
let g:pymode_lint_on_write = 0
let g:pymode_rope_completion = 0

" *** Deoplete ***
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete=1
let g:deoplete#sources#jedi#enable_typeinfo = 0 "gotta go fast

" *** Airline ***
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme = 'palenight'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1

" *** SimpylFold ***
let g:SimpylFold_docstring_preview = 1

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
let g:list_of_insert_keys = []
let g:hardtime_timeout = 1000
let g:hardtime_showmsg = 1
let g:hardtime_allow_different_key = 1

" *** FlyGrep ***
nnoremap <C-f>f :FlyGrep<cr>

" *** Bujo ***
nmap <C-S> <Plug>BujoAddnormal
imap <C-S> <Plug>BujoAddinsert
nmap <C-Q> <Plug>BujoChecknormal
imap <C-Q> <Plug>BujoCheckinsert
map <leader>t :Todo g<CR>
let g:bujo#todo_file_path = $HOME . "/.cache/bujo"
let g:bujo#window_width = 60
