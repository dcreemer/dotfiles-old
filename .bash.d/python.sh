# shellcheck disable=SC2155,SC2039
#
# python
#

if command -v pyenv 1>/dev/null 2>&1; then
    # use pyenv to choose and switch python interpreters
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi
