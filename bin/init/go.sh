#! /bin/bash
#
# (re-)bootstrap an environment
# init a new machine with "bash <(curl -fsSL https://raw.github.com/dcreemer/dotfiles/master/bin/init/go.sh)"
# can be safely re-run

echo "[START]"

# fetch dotfiles-base
if [ ! -r $HOME/.dotfiles-base ]; then
  echo "[CLONE] dotfiles-base"
  git clone git://github.com/dcreemer/dotfiles.git $HOME/.dotfiles-base
fi

# run pre-install hooks
if [ -r $HOME/.dotfiles-base/pre-install.sh ]; then
    $HOME/.dotfiles-base/pre-install.sh
fi

# install
$HOME/.dotfiles-base/bin/link-dotfiles base

# run post-install hooks
if [ -r $HOME/.dotfiles-base/pre-install.sh ]; then
    $HOME/.dotfiles-base/pre-install.sh
fi

# possibly clone private and work bootstraps:
if [ -d $HOME/Dropbox/Git ]; then
    for m in private work ; do
        REPO=$HOME/Dropbox/Git/dotfiles-${m}.git
        if [ ! -r $HOME/.dotfiles-${m} ] && [ -d $REPO ]; then
            echo "[CLONE] dotfiles-${m}"
            git clone gcrpyt::rsync:${REPO} $HOME/.dotfiles-{m}
        fi
    done
fi

for m in private work ; do
    # run pre-install hook
    if [ -r $HOME/.dotfiles-${m}/pre-install.sh ]; then
        $HOME/.dotfiles-${m}/pre-install.sh
    fi
    if [ -d $HOME/.dotfiles-${m} ]; then
        # link files
        $HOME/.dotfiles-base/bin/link-dotfiles $m
        # run post-install hook
        if [ -r $HOME/.dotfiles-${m}/post-install.sh ]; then
            $HOME/.dotfiles-${m}/post-install.sh
        fi
    fi
done

echo "[DONE]"
