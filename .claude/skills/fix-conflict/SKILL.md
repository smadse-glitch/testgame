---
name: fix-conflict
description: Resolve a merge conflict - when both of us changed the same lines - by explaining both versions in plain words and letting the person choose. Use whenever git reports a conflict during /sync, /save, /undo or /experiment.
---

# /fix-conflict: when two edits clash

1. **Explain.** `git status` lists the conflicted files. Tell the person in one line what a conflict is: both of you changed the same lines, and git needs a human to choose.
2. **Understand both sides.** For each file, read the conflict markers and the log entries behind each side (`git log --oneline --merge -- <file>`). Describe both versions as differences a player would notice, not as code. During a pull, "ours" is the person's own work and "theirs" is what came from GitHub.
3. **Ask:** keep mine, keep theirs, or combine them? Explain what combining would mean. Suggest combining when both changes can live together.
4. **Apply carefully:**
   - `.gd` scripts: edit to the chosen result and remove every conflict marker.
   - `.tscn` / `.tres` scene and resource files: these break easily. Prefer taking one whole side (`git checkout --ours <file>` or `git checkout --theirs <file>`), then re-making the other side's change as a fresh edit. Keep every `ExtResource` and `uid` reference valid.
   - `project.godot`: keep both sides' settings.
   - `docs/` files: keep both texts.
5. **Verify.** No markers left (`git grep -n "<<<<<<<"` finds nothing). Run the start check, and have the person play the affected part.
6. **Finish.** `git add <files>`, then `git commit --no-edit` (or a message describing how it was resolved). Note the resolution in this session's log, then carry on with what you were doing, usually pushing.

Never resolve a whole conflict by blindly taking one side without asking. If the person wants to stop, `git merge --abort` returns to just before the pull, without losing anything already committed.
