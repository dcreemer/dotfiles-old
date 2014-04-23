#!/usr/bin/env bash
#
# FreeBSD base pre-installation script

set -o nounset

# fetch git-remote-gcrypt to bootstrap private repos.
grc="$HOME/bin/git-remote-gcrypt"
if [ ! -r $grc ]; then
    echo "[FETCH] git-remote-gcrypt"
    curl -fsSL "https://raw.github.com/dcreemer/git-remote-gcrypt/master/git-remote-gcrypt" > $grc
    chmod a+x $grc
fi

# install packages:
for p in $(cat $HOME/.dotfiles-base/FreeBSD/packages) ; do
    pkg info -e $p
    if [ $? -eq 1 ]; then
        echo "[INSTALL] $p"
        sudo pkg install -y $p
    fi
done
