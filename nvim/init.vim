" *** Inspired by https://github.com/prlz77/nvim ***

set nocompatible
filetype off

" *** Fixes *** "
let $VTE_VERSION="100"
set guicursor=

"Source plugins and custom functions
source $HOME/.config/env_setup/nvim/config/plugins.vim
source $HOME/.config/env_setup/nvim/config/util.vim

" *** General *** "
set number              " show line numbers
set number relativenumber
set showcmd             " show command in bottom bar
set showmode            " show current mode
set ruler
set textwidth=88
set colorcolumn=+1 
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set foldenable          " enable folding
set autoread            " detect file changes
set autoindent
set smartindent

set background=dark
colorscheme OceanicNext

set clipboard=unnamedplus " clipboard

" *** Code *** "
syntax on
syntax enable
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

" *** Search ***
set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).
set laststatus=2

" *** Indentation ***"
filetype plugin indent on " load filetype-specific indent files
set expandtab " tabs are spaces
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in tab when editing
set shiftwidth=4
set smarttab

"Enable folding
set foldmethod=indent
set foldlevel=99

"Bold and italic fonts
let g:enable_bold_font = 1
let g:enable_italic_font = 1

"Remaps

"Remap Leader
let mapleader = ","

"Enable folding with the spacebar
nnoremap <space> za

"foldall
nnoremap zf zM
"openall
nnoremap zo zR

"easier moving of code blocks
vnoremap < <gv
vnoremap  > >gv

" resize horizontal split window
nmap <Up> <C-W>-<C-W>-
nmap <Down> <C-W>+<C-W>+
"resize vertical split window
nmap <Left> <C-W>><C-W>>
nmap <Right> <C-W><<C-W><
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"insert breakpoints
map <C-b> Oimport ipdb; ipdb.set_trace()  # BREAKPOINT<C-c>

"Switch buffer on tab
nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

"No highlight on search
set nohlsearch

"automatically closing the scratch window at the top of the vim window on finishing a complete or leaving insert
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif 

"Remove all trailing whitespace by pressing F5
:nnoremap <silent> <F5> :let _save_pos=getpos(".") <Bar>
    \ :let _s=@/ <Bar>
    \ :%s/\s\+$//e <Bar>
    \ :let @/=_s <Bar>
    \ :nohl <Bar>
    \ :unlet _s<Bar>
    \ :call setpos('.', _save_pos)<Bar>
    \ :unlet _save_pos<CR>

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

" *** Backups *** "
set undodir=~/.config/nvim/undodir
set undofile
set undolevels=700
set history=700
set undoreload=1000

set backupdir=~/.config/nvim/backup
set directory=~/.config/nvim/backup
