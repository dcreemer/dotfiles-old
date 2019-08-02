# shellcheck disable=SC2155,SC2039
#
# commands depending on 1pass
#


if command -v 1pass > /dev/null; then

    if command -v fzf > /dev/null; then
        fuzzpass() {
            local arg=$1
            if [ "$arg" == "" ]; then
                arg="password"
            fi
            local item=$(1pass | fzf)
            [[ -n "$item" ]] && 1pass "$item"
        }
    fi

fi
