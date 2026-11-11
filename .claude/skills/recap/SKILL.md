---
name: recap
description: Summarise everything since the last check-in (or since a date) - what changed and who did it, where we disagreed, decisions made, what's stuck, open bugs, and suggested next cards. Use when we check in together, or after a break.
argument-hint: "[since: a date, or empty for 'since the last check-in']"
---

# /recap: catch up together

1. **Range:** a date in `$ARGUMENTS`; otherwise since the last comment on the pinned "Check-in notes" issue (`gh issue list --search "Check-in notes in:title"`, then `gh issue view <N> --comments`); otherwise from the beginning.
2. **Gather:** log entries in range (the date is in each file name), decision records in range, commits without a log entry (`git log --since=<date> --oneline`), open bugs, cards in progress and Next up, the latest milestone.
3. **Write the recap** in plain words, short:
   - **What changed**, grouped by person
   - **Where we disagreed:** places where one of us changed the other's work, and why. These are the things to talk about
   - **Decisions made**
   - **Stuck or half-done:** cards in progress with no recent log entry, known issues
   - **Open bugs**
   - **Suggested next cards**
4. **After the check-in,** offer to post the notes (what we agreed, the next cards, any process fixes) as a comment on the "Check-in notes" issue. The first time, create and pin that issue (`gh issue create`, `gh issue pin`).
5. **Process fixes** we agreed on: update `CLAUDE.md` or the command in question, log it, and share with `/save`.
