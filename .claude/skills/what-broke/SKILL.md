---
name: what-broke
description: Find which change broke something that used to work, explain it in plain words, and offer to fix it or undo it. Use when the game crashes, won't start, or something that worked before doesn't.
argument-hint: "[what's wrong]"
---

# /what-broke: find the change behind a problem

1. **Understand the symptom:** what the person did, what happened, what should have happened. If the game won't start, run the start check and read the errors.
2. **Find the last good point.** Ask when it last worked, or use the latest tag (`git describe --tags --abbrev=0`), which is our last good version.
3. **List what changed since:** the log entries in `docs/log/` since then, and `git log --oneline --stat <good>..HEAD`. Rank the suspects by whether they touched the files involved in the symptom.
4. **Not obvious? Test older versions without touching the person's work.** Check out a version in a separate folder: `git worktree add /tmp/<repo>-check <commit>`. Import and run the start check there (or have the person play it), then `git worktree remove /tmp/<repo>-check`. Halve the range each time until you find the first bad change.
5. **Explain** in plain words: which change it was (log entry, who, when), what it was meant to do, and why it broke this.
6. **Offer two ways forward**, and let the person choose:
   - **Fix forward** (usually best): keep the good part of the change and repair the problem.
   - **Undo the change** with `/undo`.
7. **Log it.** Add a "What broke and why" note to this session's log, and open or close a bug card as fitting. Share with `/save`.
