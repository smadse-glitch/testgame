---
name: experiment
description: Try a risky or big idea on a separate branch without touching main, then keep it (merge it into main) or drop it. Use for "let's try something", big rewrites, or anything that may not work out.
argument-hint: "start <name> | keep | drop"
---

# /experiment: try something on the side

## start `<name>`

1. **Clean start.** Unsaved work: `/save` it first. Then get the latest `main` (`/sync` steps 1–3).
2. **Announce it on main.** Note "Experiment: `experiment/<short-name>`, trying <what>" in the person's own status file (`docs/status/<name>.md`) and a short log entry, and share it with the `/save` steps. That way the other person knows.
3. **Branch:** `git switch -c experiment/<short-name>`, then `git push -u origin experiment/<short-name>` to back it up on GitHub.
4. Tell the person: work as usual, and `/save` now saves to the experiment branch, not `main`.

## keep

1. `/save` on the experiment branch.
2. `git switch main`, then `git pull --no-rebase origin main`.
3. `git merge --no-ff experiment/<short-name>`. A conflict: follow `/fix-conflict`.
4. Run the start check and let the person play the result.
5. Log what the experiment was and that it's kept, clear it from the person's status file, and push `main` with the `/save` steps.
6. Tidy up (asks for confirmation): `git branch -d experiment/<short-name>` and `git push origin --delete experiment/<short-name>`.

## drop

1. Ask: keep the branch on GitHub for reference (the default), or delete it?
2. `git switch main`, then `/sync`.
3. On `main`, log what was tried, why it's dropped, and what we learned. Clear it from the person's status file. Share with the `/save` steps.
4. Only if they chose to delete it (asks for confirmation): `git branch -D experiment/<short-name>` and `git push origin --delete experiment/<short-name>`.
