#Taken from https://github.com/prlz77/nvim
ckup dirs
mkdir undodir
mkdir backup
# vim-plug
curl -fLo ./autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim -c :PlugInstall
pip3 install --user -r nvim/requirements.txt
