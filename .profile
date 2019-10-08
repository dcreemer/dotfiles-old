#
# profile for dcreemer
# should work with Mac OS X, FreeBSD, and Linux
#

test "$OS" || export OS="$(uname)"
export DIST="NA"
if [ "$OS" == "Linux" ]; then
    if [ "$ANDROID_ROOT" != "" ]; then
        export DIST="termux"
    elif [ "$WSL_DISTRO_NAME" != "" ]; then
        export DIST="wsl"
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
elif [ "$DIST" == "wsl" ]; then
    # inside WSL, need some Windows paths
    export WINHOME="/mnt/c/Users/D Creemer"
    PATH=$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    PATH=$PATH:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem
    PATH=$PATH:"$WINHOME/AppData/Local/Microsoft/WindowsApps"
    PATH=$PATH:"$WINHOME/AppData/Local/Keybase"
    PATH=$PATH:"$WINHOME/AppData/Local/Programs/Microsoft VS Code/bin"
    export PATH
else
    export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
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
