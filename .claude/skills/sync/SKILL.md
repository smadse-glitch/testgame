---
name: sync
description: Start-of-session catch-up. Downloads the latest main from GitHub, briefs the person in plain words on everything that changed since they last synced, and opens the game so they can play it. Use at the start of every session, or when someone asks "what changed?" or "get the latest".
---

# /sync: start of session

Goal: the person is on the latest `main`, knows in plain words what changed since they last synced, and is playing it.

1. **Check the setup** (quietly; only mention problems):
   - Not inside `.claude/worktrees/` (`git rev-parse --show-toplevel`). If it is, stop and ask the person to turn off the desktop app's **Worktree** option and start a new session in the project folder.
   - Hooks switched on: `git config core.hooksPath` prints `.githooks`. If not, run `git config core.hooksPath .githooks` and say so in one line.
   - `git lfs version` works. If not, help install it (`SETUP.md`, part 0) before continuing.
   - Godot is 4.7.2: `<godot> --version`. If not, say so and don't open the project until it is (a different version rewrites files).
2. **Check for unsaved work.** Run `git status --short` and `git branch --show-current`.
   - Uncommitted changes: describe them in plain words. Offer to `/save` them first (if the game starts) or to leave them as they are. Never throw them away. Settle this before continuing.
   - On an `experiment/...` branch: say so, and ask whether to stay there or go back to `main`.
3. **Remember where we were.** Note the current commit: `git rev-parse HEAD`. Call it OLD.
4. **Download.** `git pull --no-rebase origin main`.
   - A conflict: follow `/fix-conflict`.
   - Nothing new: say "You're up to date" and skip to step 7.
5. **Brief.** List the log entries that arrived: `git diff --name-only --diff-filter=AM OLD..HEAD -- docs/log/` (ignore `TEMPLATE.md`). Read each one and give a short briefing, oldest first, a few lines per entry:
   - who changed what, as a player would notice it, and why
   - how to try it
   - anything half-done, broken or decided (new files in `docs/decisions/` in the same range)
   - anything that changed the person's own earlier work, said neutrally: "<Name> adjusted your <thing> because <reason>."
   Also mention any new commits without a log entry (`git log --oneline OLD..HEAD`), by their message.
6. **Where the other person is.** Read the other person's file in `docs/status/`: what they're working on, which hotspot files they've claimed, what's half-done. Then, if `gh` works: open bugs (`gh issue list --label bug --state open`), cards in progress with their assignees (`gh issue list --state open`), running experiments (`git branch -r --list 'origin/experiment/*'`), and the last good version (`git describe --tags --abbrev=0`; none yet is fine).
7. **Start check.** If `.godot/` is missing, import first. Run the start check from `CLAUDE.md`. If it fails, say so plainly and offer `/what-broke`.
8. **Play.** Open the game in a window (`<godot> --path .`, in the background) and suggest what to try, based on the briefing.
9. **Next.** Ask what they want to work on. If it's a card on the board: assign it (`gh issue edit <N> --add-assignee @me`) and move it to In progress if you can; otherwise ask them to drag the card. If the work needs a hotspot file the other person has claimed, say so now.
