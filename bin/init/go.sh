#! /bin/bash
#
# (re-)bootstrap an environment
# init a new machine with "bash <(curl -fsSL https://raw.github.com/dcreemer/dotfiles/master/bin/init/go.sh)"
# can be safely re-run

echo "[START]"

if [ ! -r $HOME/.dotfiles ]; then
  echo "[CLONE] dotfiles"
  git clone git://github.com/dcreemer/dotfiles.git $HOME/.dotfiles
fi

$HOME/.dotfiles/bin/link-dotfiles base

# fetch git-remote-gcrypt to bootstrap private repos.
grc="$HOME/bin/git-remote-gcrypt"
if [ ! -r $grc ]; then
    echo "[FETCH] $git-remote-gcrypt"
    curl -fsSL "https://raw.github.com/dcreemer/git-remote-gcrypt/master/git-remote-gcrypt" > $grc
    chmod a+x $grc
fi

if [ -d $HOME/.dotfiles-private ]; then
    $HOME/.dotfiles/bin/link-dotfiles priv
fi
if [ -d $HOME/.dotfiles-work ]; then
    $HOME/.dotfiles/bin/link-dotfiles work
fi

echo "[DONE]"
