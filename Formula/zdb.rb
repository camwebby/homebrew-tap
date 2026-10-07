class Zdb < Formula
  desc "A keyboard-first terminal UI database client for PostgreSQL, MySQL and SQLite"
  homepage "https://github.com/camwebby/zdb"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/camwebby/zdb/releases/download/v0.1.2/zdb-aarch64-apple-darwin.tar.xz"
      sha256 "07af3e09ead8114342cfa4c69177451606e0ef7d4aceb0520376d97c1af00b61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/camwebby/zdb/releases/download/v0.1.2/zdb-x86_64-apple-darwin.tar.xz"
      sha256 "aae32a2108dc94551ec641354765a9f78309de6d929eda33d0342774c4bfa6f9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/camwebby/zdb/releases/download/v0.1.2/zdb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "85d2e339a3dba0581adbfaece0daa4cf2c0b90278f1251d56094a3daf5032912"
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
