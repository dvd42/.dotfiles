#Taken from https://github.com/prlz77/nvim
#backup dirs
mkdir undodir
mkdir backup
# vim-plug
curl -fLo ./autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sleep 2
nvim --headless +PlugInstall +qa
nvim --headless +PlugUpdate +qa

pip3 install --user -r requirements.txt
touch trusted_ips.txt
