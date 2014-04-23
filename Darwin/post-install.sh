#!/usr/bin/env bash
#
# Mac OS X base post-installation script

set -o nounset
set -o errexit

# fetch git-remote-gcrypt to bootstrap private repos.
grc="$HOME/bin/git-remote-gcrypt"
if [ ! -r $grc ]; then
    echo "[FETCH] git-remote-gcrypt"
    curl -fsSL "https://raw.github.com/dcreemer/git-remote-gcrypt/master/git-remote-gcrypt" > $grc
    chmod a+x $grc
fi

# install packages:
for p in $(cat $HOME/.dotfiles-base/Darwin/packages) ; do
    if [ ! -d /usr/local/Cellar/${p} ]; then
        echo "[INSTALL] $p"
        brew install $p
    fi
done
