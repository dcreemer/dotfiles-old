#! /usr/bin/env bash

# fetch git-remote-gcrypt to bootstrap private repos.
grc="$HOME/bin/git-remote-gcrypt"
if [ ! -r $grc ]; then
    echo "[FETCH] $git-remote-gcrypt"
    curl -fsSL "https://raw.github.com/dcreemer/git-remote-gcrypt/master/git-remote-gcrypt" > $grc
    chmod a+x $grc
fi

# install packages
OS=`uname`

if [ $OS == "Darwin" ]; then
    # install homebrew if needed
    if [ ! -x /usr/local/bin/brew ]; then
        ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    fi

    # install packages:
    for p in $(cat $HOME/.dotfiles-base/brew-packages) ; do
        if [ ! -d /usr/local/Cellar/${p} ]; then
            echo "[INSTALL] $p"
            brew install $p
        fi
    done
fi

if [ $OS == "Linux" ]; then
    # install packages:
    for p in $(cat $HOME/.dotfiles-base/apt-packages) ; do
        dpkg -l $p >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "[INSTALL] $p"
            sudo apt-get install -y $p
        fi
    done
fi
