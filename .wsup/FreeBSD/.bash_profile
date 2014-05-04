# -*- shell-script -*-
#
# dcreemer FreeBSD .bash_profile
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:$HOME/bin; export PATH

case "$TERM" in
    xterm*) color_prompt=yes;;
    eterm-color*) color_prompt=yes;;
    *) ;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt

# when in a terminal window, change the title bar:
case "$TERM" in
    xterm*|rxvt*)
      PS1="\[\e]0;\u@\h: \w\a\]$PS1"
      ;;
    *)
      ;;
esac

alias ls='ls -GF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ec='emacsclient'
alias ff='emacsclient -n'

# virtualenv
if [ -f "/usr/local/bin/virtualenvwrapper.sh" ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source "/usr/local/bin/virtualenvwrapper.sh"
fi

# private settings
if [ -f $HOME/.bash_private ]; then
    source $HOME/.bash_private
fi
