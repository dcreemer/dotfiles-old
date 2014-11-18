# -*- shell-script -*-
#
# dcreemer mac os x .bash_profile
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin

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
alias t='tree -aCF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ec='emacsclient'
alias ff='emacsclient -n'

# gpg
envfile="$HOME/.gnupg/gpg-agent.env"
if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
    eval "$(cat "$envfile")"
else
    eval "$(gpg-agent --daemon --write-env-file "$envfile")"
fi
export GPG_AGENT_INFO

# virtualenv
if [ -f "/usr/local/bin/virtualenvwrapper.sh" ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source "/usr/local/bin/virtualenvwrapper.sh"
fi

# jenv
if [ -d "${HOME}/.jenv/shims" ]; then
    export PATH="${HOME}/.jenv/shims:${PATH}"
    jenv rehash 2>/dev/null
    export JENV_LOADED=1
    unset JAVA_HOME
    jenv() {
      typeset command
      command="$1"
      if [ "$#" -gt 0 ]; then
          shift
      fi

      case "$command" in
          enable-plugin|rehash|shell|shell-options)
            eval `jenv "sh-$command" "$@"`;;
          *)
            command jenv "$command" "$@";;
      esac
    }
fi

# bash completion via homebrew
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# private settings
if [ -f $HOME/.bash_private ]; then
    source $HOME/.bash_private
fi

# work specific settings
if [ -f $HOME/.bash_work ]; then
    source $HOME/.bash_work
fi
