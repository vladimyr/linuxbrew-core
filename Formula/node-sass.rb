class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.29.0.tgz"
  sha256 "ab8c7ecbc4cec8a6709d1edabf6cd6679b0a870ee5a00d116ad8f708cf897823"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2c233f4e39cbe362bdde71befe77a0cd35363f029fef32ca08447258c472ba5c" => :big_sur
    sha256 "56e3e99b30e6770aadd154177343a43bb56681c5dff2fcec7b97539581c9d0ae" => :catalina
    sha256 "4d7d268582508a2dc165837a96ba655bffb4b783a7daf035b1a8011912fd941f" => :mojave
    sha256 "663b8447ee56847a676839e55058ce1c41400041fd75ba415daa5c5d37fae8e8" => :high_sierra
    sha256 "a14ccc41720080383c0b3ccb933705dc87b50deb8e5be3b0dda57f6c1ca54606" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
