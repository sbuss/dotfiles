#!/bin/bash

_vim() {
    rm -f $HOME/.vimrc
    ln -s `pwd`/vimrc $HOME/.vimrc

    rm -f $HOME/.vim/plugins
    mkdir -p $HOME/.vim
    mkdir -p $HOME/.vim/colors
    mkdir -p $HOME/.vim/swap
    mkdir -p $HOME/.vim/undo
    ln -s `pwd`/vim/plugins $HOME/.vim/plugins
    ln -sf `pwd`/vim/colors/*.vim $HOME/.vim/colors/

    mkdir -p $HOME/.vim/bundle
    local vundle_dest=$HOME/.vim/bundle/Vundle.vim
    if [[ ! -d $vundle_dest ]]; then
        git clone https://github.com/VundleVim/Vundle.vim.git $vundle_dest
    fi
    vim -u ~/.vim/plugins +PluginInstall +qall
}

_bash() {
    rm -f $HOME/.mybashrc
    if [[ ! -d $HOME/.bash ]]; then
        ln -s `pwd`/bash $HOME/.bash
    fi
    ln -s `pwd`/mybashrc $HOME/.mybashrc
    case $(uname -s) in
      Darwin)
        rm -f $HOME/.bash_profile
        ln -s `pwd`/bash_profile $HOME/.bash_profile

        # Install bash-completion if missing
        if hash brew 2>/dev/null; then
            if ! brew list bash-completion &>/dev/null && ! brew list bash-completion@2 &>/dev/null; then
                brew install bash-completion
            fi
        fi
        ;;
    esac
    if ! grep 'mybashrc' $HOME/.bashrc; then
      echo ". $HOME/.mybashrc" >> $HOME/.bashrc
    fi
}

_git() {
    rm -f $HOME/.gitglobalignore
    ln -s `pwd`/gitglobalignore $HOME/.gitglobalignore
    git config --global core.excludesfile $HOME/.gitglobalignore
}

_claude() {
    # Default claude config (~/.claude)
    mkdir -p $HOME/.claude
    rm -f $HOME/.claude/settings.json
    rm -f $HOME/.claude/statusline-command.sh
    ln -s `pwd`/claude/settings.json $HOME/.claude/settings.json
    ln -s `pwd`/claude/statusline-command.sh $HOME/.claude/statusline-command.sh

    # Blaude config (~/.claude-bacio)
    mkdir -p $HOME/.claude-bacio
    rm -f $HOME/.claude-bacio/settings.json
    rm -f $HOME/.claude-bacio/statusline-command.sh
    ln -s `pwd`/claude-bacio/settings.json $HOME/.claude-bacio/settings.json
    ln -s `pwd`/claude/statusline-command.sh $HOME/.claude-bacio/statusline-command.sh
}

_zsh() {
    rm -f $HOME/.myzshrc
    if [[ ! -d $HOME/.zsh ]]; then
        ln -s `pwd`/zsh $HOME/.zsh
    fi
    ln -s `pwd`/myzshrc $HOME/.myzshrc
    if [ -f $HOME/.zshrc ]; then
        if ! grep 'myzshrc' $HOME/.zshrc 2>/dev/null; then
            echo ". $HOME/.myzshrc" >> $HOME/.zshrc
        fi
    else
        echo ". $HOME/.myzshrc" > $HOME/.zshrc
    fi
}

_vim
_bash
_git
_claude
_zsh
