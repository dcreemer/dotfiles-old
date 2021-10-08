#
# profile for dcreemer
# should work with Mac OS X, FreeBSD, and Linux
#

test "$OS" || export OS="$(uname)"
export DIST="NA"
if [ "$OS" == "Linux" ]; then
    if [ "$ANDROID_ROOT" != "" ]; then
        export DIST="termux"
    elif [ -r /etc/os-release ]; then
        export DIST=$(grep -e '^NAME=' /etc/os-release |sed -r 's/NAME="([a-zA-Z ]+)"/\1/')
    fi
fi

export LANG="en_US.UTF-8"

# set the PATH
if [ "$DIST" == "termux" ]; then
    # inside termux, need busybox and user
    export PATH=$HOME/bin:$HOME/.local/bin:$PREFIX/bin:$PREFIX/bin/applets
    export USER=$(whoami)
else
    export PATH=/usr/sbin:/usr/bin:/sbin:/bin
    # reset HOMEBREW settings if set:
    unset HOMEBREW_PREFIX HOMEBREW_SHELLENV_PREFIX HOMEBREW_NO_ANALYTICS HOMEBREW_CELLAR HOMEBREW_REPOSITORY HOMEBREW_GITHUB_API_TOKEN
    if [ -x "/usr/local/bin/brew" ]; then
        eval $(/usr/local/bin/brew shellenv)
    elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    else
        export PATH=/usr/local/sbin:/usr/local/bin:${PATH}
    fi
    export PATH=$HOME/bin:$HOME/.local/bin:${PATH}
fi

# fn to start ssh-agent, but never inside of a tmux session
start_ssh_agent() {
    if [ "$TMUX" == "" ]; then
        pgrep ssh-agent > /dev/null
        if [ $? -ne 0 ]; then
            eval `ssh-agent -s`
        fi
    fi
}

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
