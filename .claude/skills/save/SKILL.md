---
name: save
description: Save and share work. Checks the game starts, writes the session log entry and the person's own status file, commits with a detailed message, and pushes to main, combining with the other person's work first if needed. Use after each working change, at the end of every session, or when someone says "save", "push" or "share this".
argument-hint: "[optional: what changed, in a few words]"
---

# /save: share your work

Goal: the person's work is on GitHub, the game still starts, and the other person can read what happened and why.

1. **What changed.** `git status --short` and `git diff --stat`.
   - Nothing: say there's nothing to save.
   - New images, audio, fonts or art files: check `git lfs version` works, and after `git add`, that `git lfs status` lists them as LFS. If LFS isn't installed, stop and help install it.
   - Any single file over 50 MB, or anything that looks like a secret: leave it out and ask the person.
2. **Start check** (see `CLAUDE.md`). Errors: fix them with the person, or stop. Never push a game that doesn't start. Half-done but running is fine; say so in the log.
3. **Log entry.** Create or update this session's file in `docs/log/`, named `YYYY-MM-DD-<first name>-<short-topic>.md` (first name from `git config user.name`), following `docs/log/TEMPLATE.md`. Fill it from this session: what changed as a player would notice it, why, decisions and rejected options, how to test, what's half-done or broken, files touched, cards. Use `$ARGUMENTS` if given. Show the person a 2–4 line summary and let them correct it.
   - Screenshot: optional. If the person gives one, shrink it with macOS's built-in `sips`: `sips -Z 1280 -s format jpeg -s formatOptions 70 <input> --out docs/log/img/<name>.jpg`. Keep it under 300 KB, and link it from the log.
4. **Decisions.** If a real decision was made (design, rule, tool), write a decision record (see `/decide`) or confirm with the person that it doesn't need one.
5. **Status.** Update **only this person's** file, `docs/status/<first name>.md` (create it from `docs/status/TEMPLATE.md` the first time): last session and its log, what they're working on, claimed hotspot files (release claims that are done), what's half-done, the next step, any experiment.
6. **Commit.** `git add -A`, then commit with:
   - a first line saying in plain words what changed
   - a body with what and why
   - `Log: docs/log/<file>`
   - `Refs #N`, or `Closes #N` only when the card is finished
7. **Combine.** `git pull --no-rebase origin main`.
   - A conflict: follow `/fix-conflict`.
   - New work arrived without conflict: run the start check again (their change and yours together) and fix anything broken before pushing.
8. **Push.** `git push origin main`. The `pre-push` hook runs the start check once more and uploads LFS files.
   - Rejected because the other person pushed meanwhile: go back to step 7.
   - Stopped by the hook: the game doesn't start. Fix it; never skip the hook. Never force.
9. **Board.** A finished card closes from the commit message. Otherwise comment on the card with the log file's name: `gh issue comment <N> --body "..."`.
10. **Report** in 2–3 lines: what was shared, where the log is, and that the playable link updates once GitHub has built it (offer to watch with `gh run watch`). If they touched a hotspot file, remind them to ping the other person.

**On an experiment branch:** push to that branch instead (`git push -u origin <branch>`), log as usual, and remind the person it isn't on `main` yet.
