class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.97.0",
      revision: "35df840f449e4aec5b17ce32a26ff0644b9082f9"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url "https://github.com/influxdata/flux/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "07785fc25b031f3427a9fbe4a89761381e4c0bc9c22aee3f837c614f4f88b045" => :big_sur
    sha256 "c142c9ce4c026a323183c412781b4d16b2366766b8c0373e9f045a2bd636b7af" => :catalina
    sha256 "a31a97f369e3eee86c18d45e44cffa4bee454ae4dd72bf0af764759236ed4294" => :mojave
    sha256 "215085b1ae3b3c63b2bc0250701525e7ad1db0a16e933504dfcb030fbf4e273d" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "ragel" => :build
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    on_macos do
      lib.install "libflux/target/x86_64-apple-darwin/release/libflux.dylib"
      lib.install "libflux/target/x86_64-apple-darwin/release/libflux.a"
    end
    on_linux do
      lib.install "libflux/target/x86_64-unknown-linux-gnu/release/libflux.so"
      lib.install "libflux/target/x86_64-unknown-linux-gnu/release/libflux.a"
    end
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
