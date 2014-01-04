#! /bin/bash
#
# bootstrap config
# init a new machine with "bash <(curl -fsSL https://raw.github.com/dcreemer/dotfiles/master/bin/init/go.sh)"
# can be safely re-run


if [ ! -r $HOME/.dotfiles ]; then
  echo "Checking out dotfiles..."
  git clone git://github.com/dcreemer/dotfiles.git $HOME/.dotfiles
fi

if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

$HOME/.dotfiles/bin/link-dotfiles

echo "done."
