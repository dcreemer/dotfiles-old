#! /usr/bin/env bash

# my morning ritual

function banner() {
    echo ""
    echo "======================"
    echo "$1"
    echo "======================"
    echo ""
}

banner "App Store"
mas upgrade

banner "Rust"
rustup update

banner "Brew"
brew update && brew outdated
echo "-> 'brew upgrade'"
