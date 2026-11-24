# homebrew-bothouse

`bh` — persistent work sessions on the bothouse Mac. It wraps mosh (survives
Wi-Fi drops, sleep and network changes) and tmux (keeps processes running on the
server when the client goes away).

## Install (no Homebrew needed — works on macOS 11+, Intel and Apple Silicon)

```sh
curl -fsSL https://raw.githubusercontent.com/bernardo-cs/homebrew-bothouse/main/install.sh | bash
```

Or with Homebrew (needs the Command Line Tools): `brew install bernardo-cs/bothouse/bh`

## Use

```sh
bh setup    # install iTerm2 (Terminal.app cannot receive copies from bothouse)
bh doctor   # check everything
bh          # open (or reopen) your session; lost the connection? run it again
bh help     # sessions by name, list, kill, plain-ssh fallback
bh old      # sessions made before bh 0.4 (they live on the default tmux server)
```

Copy: in iTerm2, copies made on bothouse (tmux, Claude Code) land on your Mac by
themselves. Terminal.app does not support this (no OSC 52); there, hold **Fn**
while you select with the mouse, then Cmd-C.

bh sessions run on their own tmux server on bothouse (`tmux -L bh`), apart from
the sessions Bernardo and the bots keep on the default server. On bothouse:
`tmux -L bh ls`.

Needs a `Host bothouse` entry in `~/.ssh/config` that works with plain `ssh bothouse`.
mosh comes from the official universal mosh.org package, so nothing is compiled.
