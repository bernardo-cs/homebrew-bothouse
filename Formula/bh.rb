class Bh < Formula
  desc "Persistent work sessions on the bothouse Mac (mosh + tmux)"
  homepage "https://github.com/bernardo-cs/homebrew-bothouse"
  url "https://github.com/bernardo-cs/homebrew-bothouse/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "5398ee29bded8e747bb6505876855b0806d48b8e0d7a0fb175fe717fb09c8a21"
  license "MIT"

  # Homebrew has no mosh bottle for Intel macOS, so "depends_on mosh" would
  # compile protobuf + abseil from source (and may fail on older macOS).
  # The official mosh.org package is a universal binary (x86_64 + arm64,
  # macOS 11+) linked only against system libraries: use it as-is.
  conflicts_with "mosh", because: "both install mosh and mosh-client"

  resource "mosh" do
    url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.pkg"
    sha256 "14d3ef7e0a0dfff7b284102d44da91f88a24921bbb07ff2ac6875e7075a4b207"
  end

  def install
    bin.install "bin/bh"

    pkgdir = buildpath/"mosh-pkg"
    resource("mosh").stage do
      system "pkgutil", "--expand-full", Dir["*.pkg"].first, pkgdir
    end
    payload = pkgdir/"edu.mit.mosh.mosh.pkg/Payload/local"
    bin.install payload/"bin/mosh", payload/"bin/mosh-client"
    man1.install Dir[payload/"share/man/man1/mosh*.1"]
  end

  def caveats
    <<~EOS
      First time:
        bh setup     # iTerm2, so copies made on bothouse reach this Mac
        bh doctor    # check that everything works

      Every day:
        bh           # open (or reopen) your session on bothouse
        bh help      # everything else
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bh --version")
    assert_match "mosh-client", shell_output("#{bin}/mosh-client -h 2>&1", 1)
  end
end
