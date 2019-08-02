# shellcheck disable=SC2155,SC2039
#
# Homebrew (mac, linux)
#

if command -v brew > /dev/null; then

    # bash completion via homebrew
    COMP="$(brew --prefix)"/etc/bash_completion
    if [ -f "${COMP}" ]; then
        # shellcheck source=/dev/null
        . "${COMP}"
    fi

    # Turn off homebrew analytics
    # https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
    export HOMEBREW_NO_ANALYTICS=1

    if command -v 1pass > /dev/null; then
        # github personal access token
        # see https://github.com/settings/tokens
        export HOMEBREW_GITHUB_API_TOKEN=$(1pass -p Github/homebrew-api-token)
    fi

fi
