#
# profile for dcreemer
# should work with Mac OS X, FreeBSD, and Linux
#

test "$OS" || export OS="$(uname)"
if [ "$OS" == "Linux" ] && [ -r /etc/os-release ]; then
    export DIST=$(grep -e '^NAME=' /etc/os-release |sed -r 's/NAME="([a-zA-Z ]+)"/\1/')
else
    export DIST="NA"
fi

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ "$ANDROID_ROOT" != "" ]; then
    # inside termux, need busybox
    export PATH=$PATH:/usr/bin/applets
fi

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
