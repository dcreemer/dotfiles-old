dotfiles
========

System configuration and bootstrap. To install the environment on Linux or Mac OS X, execute:

```
bash <(curl -fsSL https://raw.github.com/dcreemer/dotfiles/master/bin/init/go.sh)
```

on FreeBSD, a small amount of addition work is needed. First as root:

```
pkg install sudo bash curl
```

Remember to configure sudo (with visudo) appropriately. Then as your regular user:

```
curl -fsSL https://raw.github.com/dcreemer/dotfiles/master/bin/init/go.sh | bash
```

This project bootstraps a new computer to a workable, personalized system
with as little manual configuration as possible. This repo contains
personalized "dotfiles", a local ```$HOME/bin``` directory, and other files
needed for a basic install. The ```go.sh``` command above will clone this
repository into ```$HOME/.dotfiles/base```, and then execute commands to
create symlinks for the various dotfiles and commands.

This bootstrap process can then be repeated for other named repositories, as specified as
arguments to the ```go.sh``` script. By default "private" and "work" respositories are
configured in the script, each with further customizations. In addition to connecting symlinks
and installing packages, platform-specific ```pre-install.sh``` and ```post-install.sh``` hook
scripts will be executed if found.

Executing:

```
~/bin/init/go.sh work
```
will install and initialize the ```work``` configuration.

Executing:

```
~/bin/init/go.sh --all
```
will install and initialize all listed configurations in the order specified in ```go.sh```.

I store my non-public git repositories encrpyted with GPG and
[git-remote-gcrypt](https://github.com/joeyh/git-remote-gcrypt) on Dropbox --
see
[the code](https://github.com/dcreemer/dotfiles/blob/master/bin/init/go.sh#L47)
for how this works. Both [GPG Suite](https://gpgtools.org) and
[Dropbox](https://dropbox.com) are also automatically installed if not
preset.

Notes
=====
based on ideas from

- https://github.com/technomancy/dotfiles
- http://errtheblog.com/posts/89-huba-huba
- https://github.com/tobias/dotfiles
- https://github.com/joeyh/git-remote-gcrypt

and probably other places too....
