#!/usr/bin/env bash
#
# backup my 1Password keychain file via duplicity and also a simple ZIP/GPG archive
# intended to be run out of cron, with the GPG passphrase cached with gpg-agent.

# load's passphrases and configuration from a gpg-encrypted file. Assumes that gpg-agent
# will have the correct passphrase to decode that file cached, so no user intervention is
# needed.
. ${HOME}/bin/loadsecrets.sh

# password file(s) to backup
SOURCE="${HOME}/Dropbox/Documents/1Password.agilekeychain"

# destination. I store my backups in an IMAP mailbox on my web-accessible mail service
# final path component is duplicity subject prefix
DEST="imaps://${IMAP_USERNAME}@${IMAP_SERVER}/duplicity1p"

# path to binary
DUPLICITY="/usr/local/bin/duplicity"

# opts:
OPTS="--imap-mailbox INBOX.backups"
# allow-source-mismatch is due to my FQDN changing depending on what network I'm on.
BACKUP_OPTS="--allow-source-mismatch --full-if-older-than 1W"

# password needed to login to mail (comes from secrets file)
export IMAP_PASSWORD
# passphrase used to encrypt duplicity and zip archives:
export PASSPHRASE="${DUPLICITY_PASSPHRASE}"

# duplicity wants lots of FDs
ulimit -n 10240

# backup:
echo "BACKUP"
$DUPLICITY ${OPTS} ${BACKUP_OPTS} "${SOURCE}" "${DEST}"

# prune. keep two weeks of full backups + incrs
echo "PRUNE"
$DUPLICITY ${OPTS} --force remove-all-but-n-full 2 "${DEST}"

# verify:
echo ""
echo "VERIFY"
$DUPLICITY ${OPTS} verify "${DEST}" "${SOURCE}"

# now save a compressed copy in the remote webdav filesystem too:
echo ""
echo "COPY"

F=`mktemp -t bkup`
cd  $(dirname ${SOURCE})
zip -r - $(basename ${SOURCE}) | gpg -c --batch --yes --no-use-agent --passphrase "${PASSPHRASE}" -o "${F}"
cd -
echo "UPLOAD"
curl -T "${F}" ftp://${WEBDAV_SERVER}/backups/1pw.zip.gpg -u "${IMAP_USERNAME}:${IMAP_PASSWORD}"
rm -f ${F}

# remove secrets
unset IMAP_PASSWORD
unset IMAP_USERNAME
unset IMAP_SERVER
unset WEBDAV_SERVER
unset PASSPHRASE
