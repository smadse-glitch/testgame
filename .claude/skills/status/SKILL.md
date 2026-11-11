---
name: status
description: Read-only check of where things stand - which branch, unsaved or unpushed work, whether the other person has pushed something new, what each of us is working on, open bugs, the last good version and the latest web builds. Use any time someone is unsure or asks "where are we?". Changes nothing.
---

# /status: where are we? (changes nothing)

1. `git branch --show-current` and `git status --short`.
2. `git fetch origin` (only downloads information), then:
   - `git log --oneline HEAD..origin/main`: new from the other person, not yet synced
   - `git log --oneline origin/main..HEAD`: yours, not yet pushed
3. Read both files in `docs/status/` (as of `origin/main`: `git show origin/main:docs/status/<name>.md`): what each of us is working on, claimed hotspot files, what's half-done.
4. Shared facts from GitHub, if `gh` works: open bugs (`gh issue list --label bug --state open`), cards and their assignees (`gh issue list --state open`), running experiments (`git branch -r --list 'origin/experiment/*'`), the last good version (`git describe --tags --abbrev=0 origin/main`), and the latest web builds (`gh run list --limit 3`).
5. Answer in plain words, in about eight lines, ending with the obvious next step, for example "Run /sync to get <Name>'s change" or "Run /save to share your work".

Do not change any files, branches or commits.
