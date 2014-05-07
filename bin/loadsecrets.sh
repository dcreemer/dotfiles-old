#!/usr/bin/env bash
#
# load up the file of GPG-encrypted secrets. The loaded file is just a bunch of
# X=y statements, intended to be used by other scripts. It's generally assumed
# that the GPG passphrase will be cached by gpg-agent so that using this file
# will not be a pain.
#

SECRETS="${HOME}/.wsup/private/.wsup/misc/secrets.sh.gpg"
x=$(gpg -d ${SECRETS} 2>/dev/null | grep =)

while IFS='|' read -ra ADDR; do
    for i in "${ADDR[@]}"; do
        eval "$i"
    done
done <<< "$x"
