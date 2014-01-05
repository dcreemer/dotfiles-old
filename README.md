dotfiles
========

System configuration and bootstrap. To install the environment on a new computer, execute:

```
bash <(curl -fsSL https://raw.github.com/dcreemer/dotfiles/master/bin/init/go.sh)
```

This project bootstraps a new computer to a workable, personalized system
with as little manual configuration as possible. This repo contains
personalized "dotfiles", a local ```$HOME/bin``` directory, and other files
needed for a basic install. The ```go.sh``` command above will clone this
repository into ```$HOME/.dotfiles-base```, and then execute commands to
create symlinks for the various dotfiles and commands.

This bootstrap process will possibly then be repeated for "private" and
"work" environments, each with further environment customizations. In
addition to installing symlinks, ```pre-install.sh``` and
```post-install.sh``` hook scripts will be executed if found.

I store my non-public git repositories encrpyted with GPG and
[git-remote-gcrypt](https://github.com/joeyh/git-remote-gcrypt) on Dropbox --
see
[the code](https://github.com/dcreemer/dotfiles/blob/master/bin/init/go.sh#L47)
for how this works. Both [GPG Suite](https://gpgtools.org) and
[Dropbox](https://dropbox.com) are also automatically installed if not
preset.

Todo
====
- add Linux config

Notes
=====
based on ideas from

- https://github.com/technomancy/dotfiles
- http://errtheblog.com/posts/89-huba-huba
- https://github.com/tobias/dotfiles
- https://github.com/joeyh/git-remote-gcrypt

and probably other places too....
