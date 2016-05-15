#
# .bashrc for dcreemer
# should work on FreeBSD, Mac OS X, and Linux
#

# If not running interactively, don't do anything
if [[ $- != *i* ]]; then
    return
fi

case "$TERM" in
    xterm*) color_prompt=yes;;
    eterm-color*) color_prompt=yes;;
    screen*) color_prompt=yes;;
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

# aliases:
alias ls='ls -GF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ec='emacsclient'
alias ff='emacsclient -n'

# history:
export HISTTIMEFORMAT="[%Y-%m-%d %T] "
export HISTSIZE=1000
shopt -s histappend

# shell editor
export EDITOR="vi"

# pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init -)"
fi

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

# GPG
export GPG_TTY=$(tty)

# Mac OS X specific
if [[ "$OS" == "Darwin" ]]; then 
  # bash completion via homebrew
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi
  # Turn off analytics
  # https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
  export HOMEBREW_NO_ANALYTICS=1
fi

if [[ "$OS" == "FreeBSD" ]]; then
  # load bash completion
  if [[ $PS1 && -f /usr/local/share/bash-completion/bash_completion ]]; then
    . /usr/local/share/bash-completion/bash_completion
    # fixup todo.sh completion
    _todoElsewhere()
    {
        local _todo_sh='/usr/local/bin/todo'
        _todo "$@"
    }
    complete -F _todoElsewhere todo
  fi
fi

if [[ "$OS" == "Linux" ]]; then
  a=2
fi

# private settings
if [ -f $HOME/.bash_private ]; then
    source $HOME/.bash_private
fi

# work settings
if [ -f $HOME/.bash_work ]; then
    source $HOME/.bash_work
fi

# done

