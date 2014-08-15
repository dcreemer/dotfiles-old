#!/usr/bin/env bash
#
# update local installs
#

echo -n "lein profile... "
lein ancient upgrade-profiles

echo -n "homebrew... "
brew update
brew outdated
