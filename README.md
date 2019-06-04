# dotfiles

My current set of dotfiles. Uses [wsup](https://github.com/dcreemer/wsup) for
installation and management, though that tool is not needed to use these files.

This configuration is designed to use the
[Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) shell on Mac OS, FreeBSD,
Linux, and similar environments like WSL and [Termux](https://termux.com/). It
sets up a consistent environment general CLI usage and development.

Some features:

- Sets a few extra environment variables, suck as `OS` and `DIST`
- Ensures the `ssh-agent` is properly running and terminated as appropriate
- Sets a reasonable prompt
