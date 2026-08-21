class Povr < Formula
  desc "Pushover CLI client with native macOS notifications"
  homepage "https://github.com/vshuraeff/pushover"
  url "https://github.com/vshuraeff/pushover/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256" # fill in when v0.1.0 is tagged and pushed
  license "MIT"

  head "https://github.com/vshuraeff/pushover.git", branch: "master"

  depends_on :xcode => :build
  depends_on "go" => :build

  def install
    ldflags = "-X github.com/vshuraeff/pushover/internal/cli.Version=#{version} -X github.com/vshuraeff/pushover/internal/cli.HelperBundlePath=#{libexec}/Povr.app"
    system "go", "build", *std_go_args(output: bin/"povr", ldflags: ldflags), "./cmd/povr"
    generate_completions_from_executable(bin/"povr", "completion", shell_parameter_format: :cobra)

    bundle = libexec/"Povr.app"
    (bundle/"Contents/MacOS").mkpath
    (bundle/"Contents/Resources").mkpath
    cp "scripts/Info.plist", bundle/"Contents/Info.plist"
    cp "assets/icon/povr.icns", bundle/"Contents/Resources/povr.icns"

    ENV["CGO_ENABLED"] = "1"
    system "go", "build", "-o", bundle/"Contents/MacOS/povr-helper", "./cmd/povr-helper"
    ENV["CGO_ENABLED"] = "0"

    # ad-hoc sign with no entitlements: a restricted entitlement under
    # ad-hoc signing gets the process sigkilled by amfi.
    system "codesign", "--force", "--sign", "-", bundle
  end

  def caveats
    <<~EOS
      To enable native macOS notifications, install the signed helper
      into your user Application Support directory:
        povr helper install
      Re-run this after every `brew upgrade povr`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/povr version")
  end
end
