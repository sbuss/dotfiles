#!/bin/bash

OSX_UNAME='Darwin'
LINUX_UNAME='Linux'

_vim() {
    rm $HOME/.vimrc
    ln -s `pwd`/vimrc $HOME/.vimrc

    rm $HOME/.vim/plugins
    mkdir -p $HOME/.vim
    mkdir -p $HOME/.vim/colors
    ln -s `pwd`/vimrc_plugins $HOME/.vim/plugins
    ln -s `pwd`/my-vim-colors/*.vim $HOME/.vim/colors/

    rm -rf $HOME/.vim/bundle
    mkdir -p $HOME/.vim/bundle
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim -u ~/.vim/plugins +PluginInstall +qall
    mkdir -p $HOME/.vim/swap
}

_bash() {
    rm $HOME/.bashrc
    rm $HOME/.mybashrc
    ln -s `pwd`/bash $HOME/.bash
    ln -s `pwd`/bashrc $HOME/.bashrc
    ln -s `pwd`/mybashrc $HOME/.mybashrc
    case `uname` in
      $OSX_UNAME)
        rm $HOME/.bash_profile
        ln -s `pwd`/bash_profile $HOME/.bash_profile
        ;;
    esac
}

_git() {
    rm $HOME/.gitglobalignore
    ln -s `pwd`/gitglobalignore $HOME/.gitglobalignore
    git config --global core.excludesfile $HOME/.gitglobalignore
}

_xmonad() {
    # Xmonad
    rm $HOME/.conkyrc
    rm $HOME/.Xdefaults
    ln -s `pwd`/xmonad $HOME/.xmonad
    ln -s `pwd`/dzen $HOME/.dzen
    ln -s `pwd`/conkyrc $HOME/.conkyrc
    ln -s `pwd`/Xdefaults $HOME/.Xdefaults
}

all_platforms() {
    _vim
    _bash
    rm $HOME/.screenrc
    ln -s `pwd`/screenrc $HOME/.screenrc
    case `uname` in
      $LINUX_UNAME)
        _xmonad
      ;;
    esac
}

all_platforms
