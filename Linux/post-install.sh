#!/usr/bin/env bash
#
# Linux base pre-installation script

set -o nounset
set -o errexit

# fetch git-remote-gcrypt to bootstrap private repos.
grc="$HOME/bin/git-remote-gcrypt"
if [ ! -r $grc ]; then
    echo "[FETCH] $git-remote-gcrypt"
    curl -fsSL "https://raw.github.com/dcreemer/git-remote-gcrypt/master/git-remote-gcrypt" > $grc
    chmod a+x $grc
fi

# install packages:
for p in $(cat $HOME/.dotfiles-base/Linux/packages) ; do
    dpkg -l $p >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "[INSTALL] $p"
        sudo apt-get install -y $p
    fi
done
