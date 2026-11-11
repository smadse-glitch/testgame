# 002 · Work directly on main, no approval step

- **Date:** 2026-11-11
- **Decided by:** Sune and Maik
- **Status:** Accepted

## Question

How do we share work without getting in each other's way?

## Options considered

- **Branches and pull requests, each change approved by the other person:** protects `main`, but one person waits on the other, and there are more concepts to learn.
- **Both work on `main`:** simplest, nothing waits; a broken push affects the other person.

## Decision

We both work on `main`. Every session starts with `/sync` (get the latest, read what changed, play it) and ends with `/save` (log, commit, push). There is no approval step: if you disagree with something, change it and write why in the log. Risky ideas go on a branch via `/experiment`.

## Why

Two people, no launch, and a hobby pace: an approval gate would mostly be a bottleneck. Always building on the latest version gives each of us the full picture.

Safeguards: only push when the game starts, every push has a log entry, `/undo` takes back any change, milestones are tagged, and `.claude/settings.json` blocks force-push and history rewrites.

## Revisit if

We keep breaking each other's sessions, or more people join. Switching to branches and pull requests is a change to `CLAUDE.md` and the commands.
