#! /usr/bin/env bash

# my morning ritual

function banner() {
    echo ""
    echo "======================"
    echo "$1"
    echo "======================"
    echo ""
}

if command -v mas > /dev/null; then
    banner "App Store"
    mas upgrade
fi

if command -v rustup > /dev/null; then
    banner "Rust"
    rustup update
fi

if command -v brew > /dev/null; then
    banner "Brew"
    brew update && brew outdated
    echo "-> 'brew upgrade'"
fi
