#!/bin/bash

OSX_UNAME='Darwin'
LINUX_UNAME='Linux'

_vim() {
    rm $HOME/.vimrc
    ln -s `pwd`/vimrc $HOME/.vimrc

    rm $HOME/.vim/plugins
    mkdir -p $HOME/.vim
    mkdir -p $HOME/.vim/colors
    ln -s `pwd`/vim/plugins $HOME/.vim/plugins
    ln -s `pwd`/vim/colors/*.vim $HOME/.vim/colors/

    mkdir -p $HOME/.vim/bundle
    local vundle_dest=$HOME/.vim/bundle/Vundle.vim
    if [[ ! -d $vundle_dest ]]; then
        git clone https://github.com/gmarik/Vundle.vim.git $vundle_dest
    fi
    vim -u ~/.vim/plugins +PluginInstall +qall
    mkdir -p $HOME/.vim/swap
}

_bash() {
    rm $HOME/.mybashrc
    if [[ ! -d $HOME/.bash ]]; then
        ln -s `pwd`/bash $HOME/.bash
    fi
    ln -s `pwd`/mybashrc $HOME/.mybashrc
    case `uname -s` in
      $OSX_UNAME)
        rm $HOME/.bash_profile
        ln -s `pwd`/bash_profile $HOME/.bash_profile
        ;;
    esac
    if ! grep 'mybashrc' $HOME/.bashrc; then
      echo ". $HOME/.mybashrc" >> $HOME/.bashrc
    fi
}

_git() {
    rm $HOME/.gitglobalignore
    ln -s `pwd`/gitglobalignore $HOME/.gitglobalignore
    git config --global core.excludesfile $HOME/.gitglobalignore
}

_linux() {
    ln -s `pwd`/Xmodmap $HOME/.Xmodmap
    ln -s `pwd`/xinitrc $HOME/.xinitrc
}

all_platforms() {
    _vim
    _bash
    _git
    rm $HOME/.screenrc
    ln -s `pwd`/screenrc $HOME/.screenrc
}

all_platforms
case `uname -s` in
  $LINUX_UNAME)
    _linux
  ;;
esac
