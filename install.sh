#!/bin/bash
# Install bh + mosh without Homebrew. Uses only tools that ship with macOS
# (curl, shasum, tar, pkgutil): no Command Line Tools, no compiler, no sudo.
#
#   curl -fsSL https://raw.githubusercontent.com/bernardo-cs/homebrew-bothouse/main/install.sh | bash
set -euo pipefail

BH_REF="${BH_REF:-main}"
MOSH_URL="https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.pkg"
MOSH_SHA256="14d3ef7e0a0dfff7b284102d44da91f88a24921bbb07ff2ac6875e7075a4b207"

say() { printf '\033[1m==> %s\033[0m\n' "$*"; }
die() { printf 'install: %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "this installer is for macOS"
major=$(sw_vers -productVersion | cut -d. -f1)
[ "$major" -ge 11 ] || die "mosh needs macOS 11 or newer (this Mac: $(sw_vers -productVersion))"

if [ -d /usr/local/bin ] && [ -w /usr/local/bin ]; then
  BIN=/usr/local/bin
else
  BIN="$HOME/.local/bin"
  mkdir -p "$BIN"
fi
MAN="$(dirname "$BIN")/share/man/man1"
mkdir -p "$MAN" 2>/dev/null || MAN=""

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

say "Downloading mosh 1.4.0 (official universal package)"
curl -fsSL --retry 3 -o "$tmp/mosh.pkg" "$MOSH_URL"
echo "$MOSH_SHA256  $tmp/mosh.pkg" | shasum -a 256 -c - >/dev/null || die "mosh download is corrupt (checksum mismatch)"
pkgutil --expand-full "$tmp/mosh.pkg" "$tmp/mosh"
payload="$tmp/mosh/edu.mit.mosh.mosh.pkg/Payload/local"

say "Downloading bh ($BH_REF)"
curl -fsSL --retry 3 -o "$tmp/bh" "https://raw.githubusercontent.com/bernardo-cs/homebrew-bothouse/$BH_REF/bin/bh"
head -1 "$tmp/bh" | grep -q '^#!/bin/bash' || die "bh download looks wrong"

say "Installing into $BIN"
install -m 755 "$tmp/bh" "$payload/bin/mosh" "$payload/bin/mosh-client" "$BIN/"
[ -n "$MAN" ] && install -m 644 "$payload"/share/man/man1/mosh*.1 "$MAN/" 2>/dev/null || true

if ! command -v bh >/dev/null 2>&1 || [ "$(command -v bh)" != "$BIN/bh" ]; then
  case ":$PATH:" in *":$BIN:"*) ;; *)
    say "Add $BIN to your PATH:"
    echo "    echo 'export PATH=\"$BIN:\$PATH\"' >> ~/.zshrc && exec zsh"
  esac
fi

say "Done: $("$BIN/bh" --version)"
echo "Next:  bh doctor   (checks everything)"
echo "Then:  bh          (open your session on bothouse)"
