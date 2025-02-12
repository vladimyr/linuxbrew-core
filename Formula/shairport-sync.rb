class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.3.7.tar.gz"
  sha256 "7f8d4ecec53f2f681a962467bf09205568fc936c8c31a9ee07b1bd72d3d95b12"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "development"

  livecheck do
    url "https://github.com/mikebrady/shairport-sync/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "3db1d86ee0deaecd65c024f9918b60fcf9d14b19c147f186baa3ae8c97181f15" => :big_sur
    sha256 "65a5e9fb739fac564e2e4f70523fe6467cafd344db63394aea7faaf21d51dde2" => :catalina
    sha256 "b3c0527359c314d59d68533c1c158952818867ccb8a42a0a8a8c7afaabcc012e" => :mojave
    sha256 "0f9a03c96a43e2403592b3ff5febf5f6654f789c41fa3b45ed402de39abca793" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "pulseaudio"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pa
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    args << "--with-dns_sd" if OS.mac? # Disable bonjour in Linux
    args << "--with-os=darwin" if OS.mac?
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-pa-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end
