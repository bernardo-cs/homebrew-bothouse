# homebrew-bothouse

`bh` — persistent work sessions on the bothouse Mac. It wraps mosh (survives
Wi-Fi drops, sleep and network changes) and tmux (keeps processes running on the
server when the client goes away).

```sh
brew install OWNER/bothouse/bh
bh setup    # iTerm2 + clipboard access, so copy in tmux reaches your Mac
bh doctor   # check everything
bh          # open (or reopen) your session
```

Needs a `Host bothouse` entry in `~/.ssh/config` that works with plain `ssh bothouse`.
mosh comes from the official universal mosh.org package (Homebrew has no Intel
macOS bottle), so nothing is compiled.
