class Zdb < Formula
  desc "A keyboard-first terminal UI database client for PostgreSQL, MySQL and SQLite"
  homepage "https://github.com/camwebby/zdb"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/camwebby/zdb/releases/download/v0.1.1/zdb-aarch64-apple-darwin.tar.xz"
      sha256 "22d261b0e585b55698e900efef27a905510b30350d06174a31d1eb43e918f486"
    end
    if Hardware::CPU.intel?
      url "https://github.com/camwebby/zdb/releases/download/v0.1.1/zdb-x86_64-apple-darwin.tar.xz"
      sha256 "bd58ff330f578acde6eb94b13c8822ae041c54484d53b7d9f2255eb551271031"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/camwebby/zdb/releases/download/v0.1.1/zdb-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8f023d522e1493a4228f5e0b58a253d46272eb213e02a3ae0e637798f639d903"
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
