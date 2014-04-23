#! /usr/bin/env bash
#
# (re-)bootstrap an environment
# init a new machine with "bash <(curl -fsSL https://raw.github.com/dcreemer/dotfiles/master/bin/init/go.sh)"
# can be safely re-run

set -o nounset
set -o errexit

TARGETS=$@
OS=`uname`

# list of target -> repository URL; functions as a map
REPOS=( "base __ git://github.com/dcreemer/dotfiles.git"
        "private __ gcrypt::rsync:///Users/dcreemer/Dropbox/Git/dotfiles-private.git"
        "work __ gcrypt::rsync:///Users/dcreemer/Dropbox/Git/dotfiles-work.git" )

set_targets()
{
    # set the targets to be fetched and installed. The list of all targets are the keys of the
    # "REPOS" 'map'. Defaults to only "base"; use '--all' to run all targets
    if [[ $TARGETS == "" ]]; then
        TARGETS="base"
    elif [[ $TARGETS == "--all" ]]; then
        TARGETS=" "
        for pair in "${REPOS[@]}" ; do
            TARGETS="$TARGETS ${pair%% __ *}"
        done
    fi
}

get_repo()
{
    # given a target name, fetch the repo URL
    local k=$1
    REPO=""
    for pair in "${REPOS[@]}" ; do
        if [[ $k == "${pair%% __ *}" ]]; then
            REPO="${pair##* __ }"
        fi
    done
}

do_install()
{
    # run pre-install hook, install files, and then run post-install hook
    # for the given target
    local m=$1
    local df=$HOME/.dotfiles-${m}
    
    if [ -d $df ]; then
        
        # run pre-install hook
        if [ -r ${df}/${OS}/pre-install.sh ]; then
            ${df}/${OS}/pre-install.sh
        fi

        # install
        $HOME/.dotfiles-base/bin/link-dotfiles $m

        # run post-install hook
        if [ -r ${df}/${OS}/post-install.sh ]; then
            ${df}/${OS}/post-install.sh
        fi
        
    fi
}

bootstrap_homebrew()
{
    # install homebrew if needed
    if [ ! -x /usr/local/bin/brew ]; then
        ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    fi
}

bootstrap_git()
{
    # check to see if git is installed, and if not, install it.
    if [[ ! -x `which git` ]]; then
        echo "[INSTALL] installing git"
        case $OS in
            "Linux")
                sudo apt-get -y install git
                ;;
            "Darwin")
                bootstrap_homebrew
                brew install git
                ;;
            "FreeBSD")
                # note: assumes sudo and pkg
                sudo pkg install git
                ;;
        esac
    fi
}

fetch_repo()
{
    # given a target name, fetch the repository 
    local m=$1
    local target="$HOME/.dotfiles-$m"
    if [ ! -r $target ]; then
        echo "[CLONE] dotfiles-$m"
        get_repo $m
        git clone $REPO $target
    fi
}

execute_targets()
{
    for t in $TARGETS ; do
        echo "[TARGET] $t"
        fetch_repo $t
        do_install $t
    done
}

# main program
echo "[START]"
bootstrap_git
set_targets
execute_targets
echo "[DONE]"
