# Homebrew tap for Oko

[Oko](https://github.com/bartlomein/oko) gives Claude Code, Codex, Cursor,
OpenCode and Pi a better code search.

```sh
brew install bartlomein/tap/oko
```

Then, inside a project:

```sh
oko setup --client claude      # or codex, cursor, opencode, pi, all
```

Upgrade with `brew upgrade oko`, then run `oko upgrade` to refresh the
projects Oko is connected to.
