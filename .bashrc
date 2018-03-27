#
# .bashrc for dcreemer
# should work on FreeBSD, Mac OS X, and Linux
#

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then
    return
fi

# in crouton?
if [ -e /run/crouton-ext/socket ]; then
    export TERM=xterm-256color
fi

case "$TERM" in
    xterm*|rxvt*)
        color_prompt=yes
        set_title=yes
        ;;
    eterm-color*)
        color_prompt=yes
        # emacs Term mode behaves much like xterm
        export TERM=xterm
        ;;
    screen*)
        color_prompt=yes
        ;;
    *)
        ;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt

# when in a terminal window, change the title bar:
if [ "$set_title" = "yes" ]; then
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
fi
unset set_title

# aliases:
case "$OS" in
    Darwin)
        alias ls='ls -GF'
        ;;
    FreeBSD)
        alias ls='ls -GF'
        ;;
    Linux)
        case "$DIST" in
            Alpine*)
                alias ls='ls -F'
                ;;
            *)
                alias ls='ls --color -F'
                alias grep='grep --color=auto'
                alias fgrep='fgrep --color=auto'
                alias egrep='egrep --color=auto'
                ;;
        esac
        ;;
esac

alias ec='emacsclient'
alias ff='emacsclient -n'

# history:
export HISTTIMEFORMAT="[%Y-%m-%d %T] "
export HISTSIZE=1000
shopt -s histappend

# shell editor
export EDITOR="vi"

# GPG
export GPG_TTY=$(tty)

# Mac OS X specific
if [ "$OS" == "Darwin" ]; then
  # bash completion via homebrew
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
  # Turn off analytics
  # https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
  export HOMEBREW_NO_ANALYTICS=1
fi

# load other bash configuration
for f in ${HOME}/.bash.d/*; do
   source "$f"
done

# direnv fixes everything! https://direnv.net
eval "$(direnv hook bash)"

# done
