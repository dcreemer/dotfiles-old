#
# FreeBSD specific
#

if [ "$OS" == "FreeBSD" ]; then

    # cleanup agents on exit
    trap "{ pkill ssh-agent; pkill gpg-agent; logout; }" EXIT

fi
