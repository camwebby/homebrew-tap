class Zdb < Formula
  desc "A keyboard-first terminal UI database client for PostgreSQL, MySQL and SQLite"
  homepage "https://github.com/camwebby/zdb"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/camwebby/zdb/releases/download/v0.1.3/zdb-aarch64-apple-darwin.tar.xz"
      sha256 "c9e4cbb6e117fc4023ad6ce410be0cbf3ce986ea2500f20497e61c5baaf04855"
    end
    if Hardware::CPU.intel?
      url "https://github.com/camwebby/zdb/releases/download/v0.1.3/zdb-x86_64-apple-darwin.tar.xz"
      sha256 "d3878923137a6c476bd9aa43516e9cd2faa4800bbfa1bfd14ebc27352c22a032"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/camwebby/zdb/releases/download/v0.1.3/zdb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "40fa3ae47f753f1a0808b3b76200c953e744e9af62570364e8ca7af3cea197dd"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "zdb"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "zdb"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "zdb"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
