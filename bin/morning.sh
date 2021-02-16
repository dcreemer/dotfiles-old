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

if command -v apt-get > /dev/null; then
    banner "apt-get"
    sudo apt-get update
    sudo apt-get upgrade
fi

if command -v pkg > /dev/null; then
    banner "pkg"
    sudo pkg update
    sudo pkg upgrade
fi
