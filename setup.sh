#!/bin/bash
rm $HOME/.vimrc
rm $HOME/.bashrc
rm $HOME/.mybashrc
rm $HOME/.bash_profile
rm $HOME/.gitglobalignore
ln -s `pwd`/vimrc $HOME/.vimrc
ln -s `pwd`/bashrc $HOME/.bashrc
ln -s `pwd`/mybashrc $HOME/.mybashrc
ln -s `pwd`/bash_profile $HOME/.bash_profile
ln -s `pwd`/gitglobalignore $HOME/.gitglobalignore
git config --global core.excludesfile $HOME/.gitglobalignore
