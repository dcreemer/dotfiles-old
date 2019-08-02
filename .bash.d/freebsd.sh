# shellcheck disable=SC2155,SC2039
#
# FreeBSD specific
#

if [ "$OS" == "FreeBSD" ]; then

   # start ssh-agent on non-X shells
    if [ "$DISPLAY" == "" ]; then
       start_ssh_agent

       # cleanup agents on exit
       trap "{ pkill ssh-agent; pkill gpg-agent; logout; }" EXIT
    fi

fi
