#!/usr/bin/env bash
#
# Mac OS X base post-installation script

set -o nounset

# install brew packages:
for p in $(cat $HOME/.dotfiles-base/Darwin/packages) ; do
    if [ ! -d /usr/local/Cellar/${p} ]; then
        echo "[INSTALL] $p"
        brew install $p
    fi
done

# install git-remote-gcrypt (not in homebrew)
grc="$HOME/bin/git-remote-gcrypt"
if [ ! -r $grc ]; then
    echo "[FETCH] git-remote-gcrypt"
    curl -fsSL "https://raw.github.com/dcreemer/git-remote-gcrypt/master/git-remote-gcrypt" > $grc
    chmod a+x $grc
fi

# install gpgtools
if [ ! -x /usr/local/bin/gpg ]; then
    echo "[INSTALL] GPG Suite"
    curl -fsSL "https://releases.gpgtools.org/GPG%20Suite%20-%202013.10.22.dmg" > ~/Downloads/gpg-suite.dmg
    hdiutil attach ~/Downloads/gpg-suite.dmg
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    sudo installer -pkg "/Volumes/GPG Suite/Install.pkg" -target /
    hdiutil detach "/Volumes/GPG Suite"
    IFS=$SAVEIFS
    rm -f ~/Downloads/gpg-suite.dmg
fi

# install dropbox
if [ ! -d /Applications/Dropbox.app ]; then
    echo "[INSTALL] Dropbox"
    curl -fsSL "https://www.dropbox.com/download?plat=mac" > ~/Downloads/dropbox.dmg
    hdiutil attach ~/Downloads/dropbox.dmg
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    open "/Volumes/Dropbox Installer/Dropbox.app"
    IFS=$SAVEIFS
    rm -f ~/Downloads/dropbox.dmg
fi

# link 'subl' to sublime text
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
symlink "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "$HOME/bin/subl"
IFS=$SAVEIFS

return 0
