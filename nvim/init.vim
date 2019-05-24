" *** Inspited by https://github.com/prlz77/nvim ***

" *** Fixes *** "
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0 "Solves the garbage chars problem.
let $VTE_VERSION="100"
set guicursor=

source $HOME/.config/env_setup/nvim/config/plugins.vim

" *** General *** "
set number              " show line numbers
set number relativenumber
set showcmd             " show command in bottom bar
set showmode            " show current mode
set ruler
set colorcolumn=80
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set foldenable          " enable folding
set autoread            " detect file changes

set background=dark
colorscheme OceanicNext

set clipboard=unnamedplus " clipboard

" *** Code *** "
syntax on
syntax enable

" *** Search ***
set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).
set laststatus=2


"autocompletion settings
set completeopt=menuone,noinsert

" *** Indentation ***"
filetype plugin indent on      " load filetype-specific indent files
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
"Enable folding with the spacebar
nnoremap <space> za
"foldall
nnoremap zM zm
"openall
nnoremap zR zr

"easier moving of code blocks
vnoremap < <gv
vnorema  > >gv

" resize horzontal split window
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
map <C-b> Oimport ipbd; ipbd.set_trace()  # BREAKPOINT<C-c>

"No highlight on search
set nohlsearch

"Remove all trailing whitespace by pressing F5
:nnoremap <silent> <F5> :let _save_pos=getpos(".") <Bar>
    \ :let _s=@/ <Bar>
    \ :%s/\s\+$//e <Bar>
    \ :let @/=_s <Bar>
    \ :nohl <Bar>
    \ :unlet _s<Bar>
    \ :call setpos('.', _save_pos)<Bar>
    \ :unlet _save_pos<CR>

"remap escape to Caps_Lock
au VimEnter * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
au VimLeave * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

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

" *** Custom Functions ***

"Better navigating through completion list
function! Omnnipopup(action)
    if pumvisible()
        if a:action == 'tab'
            return "\<C-N>"
        endif
    endif
    return a:action
endfunction

inoremap <expr><silent><Tab> (pumvisible() ? '<C-R>=Omnnipopup("Tab")<CR>':'<Tab>')

"Deploy configuration
function! Deploy(server, port, dir)
    let path = a:dir
    let port = "'-e ssh -p'".a:port." "
    let rsync = "\"mkdir -p ".path." && rsync\" "

    execute "!rsync -arh --delete --exclude=.git/ ".port."--progress --rsync-path=".rsync path.' '.a:server.':'.path
endfunction

"Ip autocompletion for frequent servers
function! IpCompletion(A, L, P)
    "Replace this file with the one that contains your ips in the format
    "IP_0 Port_0\nIP_1 Port_1\n IP_2 Port_2\n
    let ip_ports = readfile($HOME.'/.config/nvim/trusted_ips.txt')
    let ips = []
    for ip in ip_ports
        call add(ips, split(ip)[0])
    endfor
    return filter(ips, 'v:val =~ "^'.a:A.'"')
endfunction

"Port autocompletion for frequent servers
function! PortCompletion(A, L, P)
    "Replace this file with the one that contains your ips in the format
    "IP_0 Port_0\nIP_1 Port_1\n IP_2 Port_2\n
    let ip_ports = readfile($HOME.'/.config/nvim/trusted_ips.txt')
    let ips = []
    for ip in ip_ports
        call add(ips, split(ip)[1])
    endfor
    return filter(ips, 'v:val =~ "^'.a:A.'"')
endfunction

function! DirCompletion(A, L, P)
    let dir = []
    call add(dir, expand('%:p:h').'/')
    return filter(dir, 'v:val =~ "^'.a:A.'"')
endfunction

function! DeployCompletion(A, L, P)
    let l = split(a:L[:a:P-1], '\%(\%(\%(^\|[^\\]\)\\\)\@<!\s\)\+', 1)
    let n = len(l) - index(l, 'Sync') - 2
    let funcs = ['IpCompletion', 'PortCompletion', 'DirCompletion']
    return call(funcs[n], [a:A, a:L, a:P])
endfunction

"Run this after neomake finishes
function! Graph(job_status)
    if a:job_status['status'] == 0
        execute "!display pycallgraph.png"
        call feedkeys("\<CR>")
    else
        copen
    endif
endfunction

function! Mem(job_status)
    if a:job_status['status'] == 0
        echo items(a:job_status)
        NeomakeCancelJob a:job_status['id']
    else
        copen
    endif
endfunction

function! Plain(job_status)
    copen
endfunction

function! InitProject(root)
    execute "PymodeRopeNewProject ".a:root

endfunction
"
"Cprofiler function
function! Profiler(file, ...)
    "profiler mode (graph:execution graph and time, mem: lots of nice stuff,
    "plain: just Cprofile output on plaintext'
    let arg1 = get(a:, 1, "mem") "default mode
    if arg1 == "graph"
        call neomake#Sh("pycallgraph --max-depth=4 -v graphviz -- ".a:file, function('Graph'))
    elseif arg1 == "mem"
         call neomake#Sh("vprof -c cmhp ".a:file, function('Mem'))
    elseif arg1 == 'plain'
        call neomake#Sh("python3 -m cProfile -s cumtime ".a:file, function('Plain'))

    endif
endfunction

command! Clean execute "!rm ~/.config/nvim/backup/*"

"create Sync command to deploy
command! -complete=customlist,DeployCompletion -nargs=* Sync call Deploy(<f-args>)

"run cProfile on file
command! -complete=file -nargs=+ Profile call Profiler(<f-args>)

"Correct lint errors
command! Lint execute "PymodeLintAuto "

"Initialize ropeproject on current dir
command! -complete=file -nargs=+ Init call InitProject(<f-args>)
