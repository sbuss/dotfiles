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

    mkdir -p $HOME/.vim/bundle
    local vundle_dest=$HOME/.vim/bundle/Vundle.vim
    if [[ ! -d $vundle_dest ]]; then
        git clone https://github.com/gmarik/Vundle.vim.git $vundle_dest
    fi
    vim -u ~/.vim/plugins +PluginInstall +qall
    mkdir -p $HOME/.vim/swap
}

_bash() {
    rm $HOME/.bashrc
    rm $HOME/.mybashrc
    if [[ ! -d $HOME/.bash ]]; then
        ln -s `pwd`/bash $HOME/.bash
    fi
    ln -s `pwd`/bashrc $HOME/.bashrc
    ln -s `pwd`/mybashrc $HOME/.mybashrc
    case `uname -s` in
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
    if [[ ! -d $HOME/.xmonad ]]; then
        ln -s `pwd`/xmonad $HOME/.xmonad
    fi
    if [[ ! -d $HOME/.dzen ]]; then
        ln -s `pwd`/dzen $HOME/.dzen
    fi
    ln -s `pwd`/conkyrc $HOME/.conkyrc
    ln -s `pwd`/Xdefaults $HOME/.Xdefaults
    ln -s `pwd`/xmobar $HOME/.xmobar
}

_linux() {
    ln -s `pwd`/Xmodmap $HOME/.Xmodmap
    ln -s `pwd`/xinitrc $HOME/.xinitrc
    if [[ ! -d $HOME/scripts ]]; then
        ln -s `pwd`/scripts $HOME/scripts
    fi
    rm $HOME/.config/redshift.conf
    ln -s `pwd`/redshift.conf $HOME/.config/redshift.conf
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
    _xmonad
    _linux
  ;;
esac
