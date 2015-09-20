#!/bin/bash
rm $HOME/.vimrc
rm $HOME/.vim/plugins
rm $HOME/.bashrc
rm $HOME/.mybashrc
rm $HOME/.screenrc
rm $HOME/.bash_profile
rm $HOME/.gitglobalignore
mkdir -p $HOME/.vim
mkdir -p $HOME/.vim/colors
ln -s `pwd`/vimrc $HOME/.vimrc
ln -s `pwd`/vimrc_plugins $HOME/.vim/plugins
ln -s `pwd`/my-vim-colors/*.vim $HOME/.vim/colors/
ln -s `pwd`/bashrc $HOME/.bashrc
ln -s `pwd`/mybashrc $HOME/.mybashrc
ln -s `pwd`/screenrc $HOME/.screenrc
ln -s `pwd`/bash_profile $HOME/.bash_profile
ln -s `pwd`/gitglobalignore $HOME/.gitglobalignore
git config --global core.excludesfile $HOME/.gitglobalignore

rm -rf $HOME/.vim/bundle
mkdir -p $HOME/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -u ~/.vim/plugins +PluginInstall +qall
mkdir -p $HOME/.vim/swap
