class Oko < Formula
  desc "Code search for coding agents, with exact excerpts from your code"
  homepage "https://github.com/bartlomein/oko"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/bartlomein/oko/releases/download/v0.9.1/oko-v0.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "204965d8d7668796b65c2047ec7d4dd9e4f8e2bbc29c33f47c2dbee262dedf17"
    end
    on_intel do
      url "https://github.com/bartlomein/oko/releases/download/v0.9.1/oko-v0.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "c342c8ab4dc1dd3218673eb9e690fd4dc392bfd92999c6720c6b88792b665744"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bartlomein/oko/releases/download/v0.9.1/oko-v0.9.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "01fce637b661855f02ae1ff249e7a80c0edc005563d172d3880536d376704c10"
    end
    on_intel do
      url "https://github.com/bartlomein/oko/releases/download/v0.9.1/oko-v0.9.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1809f8df383828ef68d8143a2dba1f23370eb157d8a24cc0f7e80dce6a7ce4a7"
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
