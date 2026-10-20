class Oko < Formula
  desc "Code search for coding agents, with exact excerpts from your code"
  homepage "https://github.com/bartlomein/oko"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bartlomein/oko/releases/download/v0.9.0/oko-v0.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "902ad7f2f54615120360802318c5baed4bbb1b70001f834a3cbff0b2fc79c503"
    end
    on_intel do
      url "https://github.com/bartlomein/oko/releases/download/v0.9.0/oko-v0.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "ac6a88ee0d97c00aafe17edc2757f3f9cbcb0406006a647c7f27f12b8335f074"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bartlomein/oko/releases/download/v0.9.0/oko-v0.9.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "35d2baf89301937f9fd99fe7fbe4303bc114cb0dbf79876fb3895fd64a37fa94"
    end
    on_intel do
      url "https://github.com/bartlomein/oko/releases/download/v0.9.0/oko-v0.9.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b679cf84b5a5bae28030770100d39f4a79f42bf4cb0b380705e9cabcc27b87da"
    end
  end

  def install
    # The bundled ripgrep stays private to Oko, beside its binary, so it never
    # shadows a ripgrep the user installed.
    libexec.install "oko", "rg"
    (bin/"oko").write_env_script libexec/"oko", OKO_RIPGREP: libexec/"rg"
    doc.install "README.md", "BUILD.json"
    prefix.install "LICENSE", "THIRD_PARTY_NOTICES.md", "licenses"
  end

  def caveats
    <<~EOS
      Connect Oko to a project's coding tools from inside that project:
        oko setup --client claude      # or codex, cursor, opencode, pi, all
      Setup keeps its own copy for the projects it connects. After
      `brew upgrade oko`, run `oko upgrade` to refresh those projects.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oko --version")
    (testpath/"app.py").write("def retry_backoff():\n    return 2\n")
    output = shell_output("#{bin}/oko ask --no-jev 'where is retry backoff defined'")
    assert_match "app.py", output
  end
end
