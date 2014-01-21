#! /bin/bash
#
# (re-)bootstrap an environment
# init a new machine with "bash <(curl -fsSL https://raw.github.com/dcreemer/dotfiles/master/bin/init/go.sh)"
# can be safely re-run

do_install()
{
    # run pre-install hook, install and run post-install hook
    # for the given param
    m=$1
    DF=$HOME/.dotfiles-${m}
    
    if [ -d $DF ]; then
        
        # run pre-install hook
        if [ -r ${DF}/pre-install.sh ]; then
            ${DF}/pre-install.sh
        fi

        # install
        $HOME/.dotfiles-base/bin/link-dotfiles $m

        # run post-install hook
        if [ -r ${DF}/post-install.sh ]; then
            ${DF}/post-install.sh
        fi
        
    fi
}

echo "[START]"

# fetch dotfiles-base
if [ ! -r $HOME/.dotfiles-base ]; then
  echo "[CLONE] dotfiles-base"
  git clone git://github.com/dcreemer/dotfiles.git $HOME/.dotfiles-base
fi

# install
do_install base

# if available, clone and install private and work bootstraps
REPOS="private"
if [ -f $HOME/.work-enabled ]; then
    REPOS="private work"
else
    echo "[SKIP] not ~/.work-enabled"
fi
for m in $REPOS ; do
    # check Dropbox for encrypted repositories
    REPO=$HOME/Dropbox/Git/dotfiles-${m}.git
    if [ ! -r $HOME/.dotfiles-${m} ] && [ -d $REPO ]; then
        # clone:
        echo "[CLONE] dotfiles-${m}"
        git clone gcrypt::rsync://${REPO} $HOME/.dotfiles-${m}

        # install:
        do_install $m
    fi
done

echo "[DONE]"
