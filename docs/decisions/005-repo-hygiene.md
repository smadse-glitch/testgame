# 005 · Repo hygiene: status per person, LFS from day one, checks on every push

- **Date:** 2026-11-11
- **Decided by:** Sune and Maik, after Maik's Claude reviewed the plan
- **Status:** Accepted

## Question

The review found places where working together on `main` would cause trouble. What do we change before the first commit?

## Options considered

- **Keep the kit as it was:** one shared status file, binary files in plain git, the start check run by Claude and by GitHub after a push.
- **Fix the weak spots now,** while the repo is empty and changes cost nothing.

## Decision

1. **No shared status file.** Each person has their own `docs/status/<name>.md`. Shared facts come from GitHub: the last good version is the latest tag, bugs and who's on what are the issues and the board, experiments are the `experiment/...` branches.
2. **Git LFS from the first commit** for images, audio, fonts and art files (`.gitattributes`). Log screenshots are shrunk to JPEGs under 300 KB.
3. **A `pre-push` git hook** runs the start check before any push, whether from Claude, a terminal or GitHub Desktop. The same check runs on GitHub after each push.
4. **Hotspot files** that everything touches (`project.godot`, `export_presets.cfg`, autoloads, repo config) are claimed in your status file before editing.
5. **Godot is pinned at exactly 4.7.2** for both of us, checked by `/sync`.
6. **`main` is protected on GitHub** against force-pushes and deletion, where our plan allows it (public repo, or GitHub Pro). Direct pushes stay allowed.
7. **No worktrees:** the desktop app's Worktree option stays off.

## Why

- Two people rewriting one status file on every save would conflict constantly.
- LFS is free up to 10 GiB of storage and bandwidth on GitHub's free plan. Starting with it avoids moving files into LFS later, which would mean rewriting history.
- Claude's own settings only stop Claude; the hook and the GitHub rule also cover pushes made by hand.

## Revisit if

The hook gets in the way more than it helps, or LFS usage approaches the free limits.
