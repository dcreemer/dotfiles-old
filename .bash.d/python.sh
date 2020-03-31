# shellcheck disable=SC2155,SC2039
#
# python
#

if command -v pyenv 1>/dev/null 2>&1; then
    # use pyenv to choose and switch python interpreters
    eval "$(pyenv init -)"
fi
