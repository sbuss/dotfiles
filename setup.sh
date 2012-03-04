#!/bin/bash
ln -s `pwd`/vimrc $HOME/.vimrc
ln -s `pwd`/bashrc $HOME/.bashrc
ln -s `pwd`/mybashrc $HOME/.mybashrc
ln -s `pwd`/bashrc $HOME/.bash_profile
ln -s `pwd`/gitglobalignore $HOME/.gitglobalignore
git config --global core.excludesfile $HOME/.gitglobalignore
