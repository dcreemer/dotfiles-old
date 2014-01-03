#! /bin/bash
#
# bootstrap config
#
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
