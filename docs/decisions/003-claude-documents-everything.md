# 003 · Claude documents every change and decision

- **Date:** 2026-11-11
- **Decided by:** Sune and Maik
- **Status:** Accepted

## Question

How does each of us keep full context on what the other did, especially when something breaks?

## Options considered

- **Rely on commit messages:** too terse for people who don't read code.
- **One shared changelog file:** two people pushing around the same time would clash over it.
- **A log file per session, plus decision records and a status page:** more files, but nothing clashes and everything is findable.

## Decision

Claude writes a log entry for every session (`docs/log/`), a decision record for every real decision (`docs/decisions/`), and keeps each person's own status file current (`docs/status/<name>.md`). No push without a log entry. `/sync` and `/recap` turn the logs into plain-language briefings.

Shared facts that both of us would otherwise edit (last good version, open bugs, who's on what) come from GitHub instead: tags, issues and the board. See decision 005.

## Why

Our Claude chats are private to each of us; only the repo is shared. Detailed logs let `/what-broke` find the change behind a problem, and let either of us pick up the other's work.

## Revisit if

The logs grow too long to be useful. Then we summarise older ones, rather than writing less.
