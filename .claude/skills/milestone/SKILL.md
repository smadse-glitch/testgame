---
name: milestone
description: Mark a version we're happy with - tag it (e.g. v0.5), write release notes from the logs, publish a GitHub release and the playable web build. Use when we reach a gate in the plan or want a known-good point to return to.
argument-hint: "[version, e.g. v0.5]"
---

# /milestone: mark a good version

1. **Latest and clean:** follow `/sync` steps 1–3. Run the start check, and ask the person to play it through once to confirm it's good.
2. **Version name:** `$ARGUMENTS`, or ask (v0.1, v0.5, v1.0…). Check it isn't taken: `git tag -l <version>`.
3. **Release notes** from the log entries since the previous tag (`git describe --tags --abbrev=0`; for the first milestone, all logs). Player-facing changes first, then known issues, then who did what. Show the notes to the person and adjust.
4. **Tag:** `git tag -a <version> -m "<one-line summary>"`, then `git push origin <version>`.
5. **Release:** write the notes to a temporary file, then `gh release create <version> --title "<version>" --notes-file <file>`.
6. **Web build:** with GitHub Pages it updates by itself from `main`. With itch.io (private repo), export and upload as in `SETUP.md` part E.
7. **Record it:** the tag is now our last good version, which `/status`, `/sync` and `/what-broke` read. Write a log entry and share with the `/save` steps.
