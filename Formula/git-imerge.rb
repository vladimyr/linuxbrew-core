class GitImerge < Formula
  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/v1.1.0.tar.gz"
  sha256 "62692f43591cc7d861689c60b68c55d7b10c7a201c1026096a7efc771df2ca28"
  license "GPL-2.0"
  head "https://github.com/mhagger/git-imerge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "89d2e824ebd85a2f3682f59387b579605c1479b1ebb73293d117ba70aa14f0cd" => :big_sur
    sha256 "18c1258aaf3bf4614044a508f4e9189ea2a4c751bafb3885f36147662010a435" => :catalina
    sha256 "5abf5b539420bb46a8ab7b10e43126b3719e2ebc6e0a37fc18434027ed816995" => :mojave
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :high_sierra
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :sierra
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :el_capitan
    sha256 "b55716121b1650d60aa9fc4063a4397d09fcb6c74c724368d15cb31378069ae5" => :x86_64_linux
  end

  def install
    bin.mkpath
    # Work around Makefile insisting to write to $(DESTDIR)/etc/bash_completion.d
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end

  test do
    system bin/"git-imerge", "-h"
  end
end
