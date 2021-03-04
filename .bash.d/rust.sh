# shellcheck disable=SC2155
#
# rust:
#

cargobin="$HOME/.cargo/bin"

if [ -e "${cargobin}" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi
