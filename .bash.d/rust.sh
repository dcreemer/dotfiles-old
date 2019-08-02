# shellcheck disable=SC2155
#
# rust:
#

cargobin="$HOME/.cargo/bin"

if [ -x "${cargobin}/rustc" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"

    if [ -x "${cargobin}/racer" ]; then
        # support rust autocompletion
        export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
    fi

fi
