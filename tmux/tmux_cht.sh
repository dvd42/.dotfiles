#! /bin/bash
languages=`echo "python bash tmux zsh" | tr ' ' '\n'`
core_utils=`echo "find tar xargs git git-commit git-rebase" | tr ' ' '\n'`

selected=`printf "$languages\n$core_utils" | fzf`

if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if printf $languages | grep -qs $selected; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi
