#
# Mac OS X specific
#

if [ "$OS" == "Darwin" ]; then

    # bash completion via homebrew
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
  
    # Turn off homebrew analytics
    # https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
    export HOMEBREW_NO_ANALYTICS=1

fi
