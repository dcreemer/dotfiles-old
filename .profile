#
# profile for dcreemer
# should work with Mac OS X, FreeBSD, and Linux
#

test "$OS" || export OS="$(uname)"
if [[ "$OS" == "Linux" ]]; then
    export DIST=$(grep -e '^NAME=' /etc/os-release |sed -r 's/NAME="([a-zA-Z ]+)"/\1/')
else
    export DIST="NA"
fi

if [ -L /bin/ls ] && [ "/bin/busybox" == $(readlink /bin/ls) ]; then
    USING_BUSYBOX="yes"
fi

export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ "$BASH" ] && [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
