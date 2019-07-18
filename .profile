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

export LANG=en_US.UTF-8

# set the PATH
if [ "$DIST" == "termux" ]; then
    # inside termux, need busybox and user
    export PATH=$HOME/bin:$HOME/.local/bin:$PREFIX/bin:$PREFIX/bin/applets
    export USER=$(whoami)
else
    export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
fi

# do not start SSH agent inside tmux
if [ "$TMUX" == "" ]; then
    # on termux or non-X FreeBSD, need ssh-agent
    if [ "$DIST" == "termux" ] || ( [ "$OS" == "FreeBSD" ] && [ "$DISPLAY" == "" ] ); then
        eval `ssh-agent -s`
    fi
fi

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
