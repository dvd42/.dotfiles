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
    execute "!rsync -arh --delete --safe-links --update --exclude-from=".$HOME."/.config/nvim/rsync_exclude.txt ".port."--progress --rsync-path=".rsync path.' '.a:server.':'.path
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
