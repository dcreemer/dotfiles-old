# shellcheck disable=SC2039
#
# WSL specific
#

if [ "$DIST" == "wsl" ]; then

    # start ssh-agent if needed
    start_ssh_agent

fi
