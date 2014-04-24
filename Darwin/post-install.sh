#!/usr/bin/env bash
#
# Mac OS X base post-installation script

set -o nounset

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
if [[ ! -h $HOME/bin/subl ]]; then
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" "$HOME/bin/subl"
    IFS=$SAVEIFS
fi
