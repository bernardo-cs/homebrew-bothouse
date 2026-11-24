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
bh doctor   # check everything
bh          # open (or reopen) your session; lost the connection? run it again
bh help     # sessions by name, list, kill, plain-ssh fallback
```

Copy text in Terminal.app: hold **Fn** while you select with the mouse, then Cmd-C.

Needs a `Host bothouse` entry in `~/.ssh/config` that works with plain `ssh bothouse`.
mosh comes from the official universal mosh.org package, so nothing is compiled.
