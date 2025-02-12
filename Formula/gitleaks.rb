class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.0.1.tar.gz"
  sha256 "4213eb282cc08fc88781d7cd933cdb48449b75a19e8634b5e4e68b035ddaed47"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f466f07689df3c5deb4b84e493ad61a030bdfc6c72b4dc4493f0e34b1999e46e" => :big_sur
    sha256 "fe23ea4c7beddc68ceb7aaea121c991ec092f6c874d824da08b04d7c427d0209" => :catalina
    sha256 "dc807cb589181e9daa7672f5a66ea237d43805b97099c9f7ec25db8a82b79ee5" => :mojave
    sha256 "685c106148206c987cc9deb271825e0136d42dfc7fe0b3045aa56592b453a276" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}",
                 *std_go_args
  end

  test do
    output = shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git 2>&1", 1)
    assert_match "level=info msg=\"cloning... https://github.com/gitleakstest/emptyrepo.git\"", output
    assert_match "level=error msg=\"remote repository is empty\"", output

    assert_equal version, shell_output("#{bin}/gitleaks --version")
  end
end
