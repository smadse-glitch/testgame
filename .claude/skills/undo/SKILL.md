---
name: undo
description: Safely take back a change that's already been shared, or roll the game back to a tagged good version, without deleting any history. Use when someone says "undo that", "remove that change" or "go back to the version that worked".
argument-hint: "[which change, or a version like v0.5]"
---

# /undo: take a change back, keeping history

1. **Identify what to undo:** one change (a log entry, a commit, or "the last thing I pushed"), or a tagged version to return to. Describe it back in plain words (what it did, who, when) and confirm. If it's the other person's work, say so, and note that the log will explain why it was undone.
2. **Only unsaved edits?** Then nothing in the history needs undoing. Offer to restore just those files (`git restore <file>`). Confirm first: this throws away edits that were never saved.
3. **Undo one change:** `git revert --no-edit <commit>` (for a merge commit: `git revert -m 1 <commit>`). For several related commits, revert the newest first.
4. **Roll back to a version:** `git revert --no-commit <tag>..HEAD`, then one commit: "Roll back to <tag>". The history keeps everything; nothing is deleted.
5. **Conflicts:** follow `/fix-conflict`. Then run the start check and let the person play the result.
6. **Log and share:** in this session's log, say what was undone, why, and how to get it back ("revert the revert"). Then follow the `/save` steps.

Never use `git reset --hard`, force-push or other history rewrites; they're blocked, and an undo never needs them.
