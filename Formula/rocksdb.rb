class Rocksdb < Formula
  desc "Embeddable, persistent key-value store for fast storage"
  homepage "https://rocksdb.org/"
  url "https://github.com/facebook/rocksdb/archive/v6.11.4.tar.gz"
  sha256 "6793ef000a933af4a834b59b0cd45d3a03a3aac452a68ae669fb916ddd270532"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "0365931b288f5eba6cebab4cc74e00735cd9a32431a944ccacdc22af3f30523d" => :big_sur
    sha256 "e480342b56120c038d7d29de482eea256f3d4b4b173701a37fdf9afddf92b9a9" => :catalina
    sha256 "230c7bb4164b9a819da6b8118252c650e6b71a04769bfd242d3e561ab9361cc2" => :mojave
    sha256 "c08fc8d6ad16f159fe8a2dccf118752e730fad45840c95ed2cf34cf875474c66" => :high_sierra
  end

  depends_on "gflags"
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    ENV["PORTABLE"] = "1"
    ENV["DEBUG_LEVEL"] = "0"
    ENV["USE_RTTI"] = "1"
    ENV["ROCKSDB_DISABLE_ALIGNED_NEW"] = "1" if MacOS.version <= :sierra
    ENV["DISABLE_JEMALLOC"] = "1" # prevent opportunistic linkage

    # build regular rocksdb
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "tools"
    system "make", "install", "INSTALL_PATH=#{prefix}"

    bin.install "sst_dump" => "rocksdb_sst_dump"
    bin.install "db_sanity_test" => "rocksdb_sanity_test"
    bin.install "db_stress" => "rocksdb_stress"
    bin.install "write_stress" => "rocksdb_write_stress"
    bin.install "ldb" => "rocksdb_ldb"
    bin.install "db_repl_stress" => "rocksdb_repl_stress"
    bin.install "rocksdb_dump"
    bin.install "rocksdb_undump"

    # build rocksdb_lite
    ENV.append_to_cflags "-DROCKSDB_LITE=1"
    ENV["LIBNAME"] = "librocksdb_lite"
    system "make", "clean"
    system "make", "static_lib"
    system "make", "shared_lib"
    system "make", "install", "INSTALL_PATH=#{prefix}"

    if OS.linux?
      # Strip the binaries to reduce their size.
      system "strip", *(Dir[bin/"*"] + Dir[lib/"*"]).select { |f| Pathname.new(f).elf? }
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <rocksdb/options.h>
      #include <rocksdb/memtablerep.h>
      using namespace rocksdb;
      int main() {
        Options options;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "db_test", "-v",
                                "-std=c++11",
                                *(["-stdlib=libc++", "-lstdc++"] if OS.mac?),
                                "-lz", "-lbz2",
                                "-L#{lib}", "-lrocksdb_lite",
                                "-DROCKSDB_LITE=1",
                                "-L#{Formula["snappy"].opt_lib}", "-lsnappy",
                                "-L#{Formula["lz4"].opt_lib}", "-llz4",
                                "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./db_test"

    assert_match "sst_dump --file=", shell_output("#{bin}/rocksdb_sst_dump --help 2>&1")
    assert_match "rocksdb_sanity_test <path>", shell_output("#{bin}/rocksdb_sanity_test --help 2>&1", 1)
    assert_match "rocksdb_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_stress --help 2>&1", 1)
    assert_match "rocksdb_write_stress [OPTIONS]...", shell_output("#{bin}/rocksdb_write_stress --help 2>&1", 1)
    assert_match "ldb - RocksDB Tool", shell_output("#{bin}/rocksdb_ldb --help 2>&1")
    assert_match "rocksdb_repl_stress:", shell_output("#{bin}/rocksdb_repl_stress --help 2>&1", 1)
    assert_match "rocksdb_dump:", shell_output("#{bin}/rocksdb_dump --help 2>&1", 1)
    assert_match "rocksdb_undump:", shell_output("#{bin}/rocksdb_undump --help 2>&1", 1)
  end
end
