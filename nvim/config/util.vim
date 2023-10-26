" *** This file holds some custom functions and commands ***

vim.cmd([[
    "Better navigating through completion list
    function! Omnnipopup(action)
        if pumvisible()
            if a:action == 'tab'
                return "\<C-N>"
            elseif a:action == "s-tab"
                return "\<C-P>"
            endif
        endif
        return a:action
    endfunction

    "Deploy configuration
    function! Deploy(server, port, dir, ...)
        let path = a:dir "destination and folder to sync
        let port = "'-e ssh -p'".a:port." " "specific port
        let rsync = "\"mkdir -p ".path." && rsync\" " "create folder if it does not exist

        " extra excludes
        let exclude = ""
        for dir in a:000
            let exclude = exclude." --exclude ".dir." "
        endfor

        execute "!rsync -arh --delete --safe-links --update ".exclude." --backup --backup-dir=".path."_backup --exclude-from=".$HOME."/.config/nvim/rsync_exclude.txt ".port."--progress --rsync-path=".rsync path.' '.a:server.':'.path. " && ssh ".a:server. " -p".a:port.' "'."cd ".path." && find . -type f -exec rm -f ".path."_backup/{} \\; "." && find ".path."_backup/ -type d -empty -delete".'"'
        echom exclude." --backup"
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

    " Complete with full path for current dir
    function! DirCompletion(A, L, P)
        let dir = []
        call add(dir, expand('%:p:h').'/')
        return filter(dir, 'v:val =~ "^'.a:A.'"')
    endfunction

    " file system completion
    function! File(A, L, P)
        return filter(systemlist("ls"), 'v:val =~ a:A')
    endfunction

    " This configurates the autocompletion for the Deploy function
    function! DeployCompletion(A, L, P)
        let l = split(a:L[:a:P-1], '\%(\%(\%(^\|[^\\]\)\\\)\@<!\s\)\+', 1)
        let n = len(l) - index(l, 'Sync') - 2
        let funcs = ['IpCompletion', 'PortCompletion', 'DirCompletion']

        " file autocompletion for extra args
        if n + 1 > len(funcs)
            return call('File', [a:A, a:L, a:P])
        endif

        return call(funcs[n], [a:A, a:L, a:P])
    endfunction

    command! Clean execute "!rm ~/.config/nvim/backup/*"

    "create Sync command to deploy
    command! -complete=customlist,DeployCompletion -nargs=* Sync call Deploy(<f-args>)]])
