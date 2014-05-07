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
duplicity ${OPTS} ${BACKUP_OPTS} "${SOURCE}" "${DEST}"

# prune. keep two weeks of full backups + incrs
echo "PRUNE"
duplicity ${OPTS} remove-all-but-n-full 2 "${DEST}"

# verify:
echo ""
echo "VERIFY"
duplicity ${OPTS} verify "${DEST}" "${SOURCE}"

# now save a zipped copy in the remote webdav filesystem too:
echo ""
echo "COPY"
# mount webdav server if needed:
if [[ ! -d "/Volumes/${WEBDAV_SERVER}" ]]; then
    osascript -e " mount volume \"https://${WEBDAV_SERVER}/\" "
fi

if [[ -r "/Volumes/${WEBDAV_SERVER}/backups" ]]; then
    cd $(dirname ${SOURCE})
    # zip, gpg symmetric encrypt, and store:
    zip -r - $(basename ${SOURCE}) | gpg -c --batch --yes --passphrase "${PASSPHRASE}" -o "/Volumes/${WEBDAV_SERVER}/backups/1pw.zip.gpg"
    # unmount volume and return to previous dir
    umount "/Volumes/${WEBDAV_SERVER}"
    cd -
else
    echo "can't mount webdavs backup target"
fi

# remove secrets
unset IMAP_PASSWORD
unset IMAP_USERNAME
unset IMAP_SERVER
unset WEBDAV_SERVER
unset PASSPHRASE
