# [GAME NAME]

A hobby game by Sune and Maik, built in Godot with Claude.

**Play the latest version:** https://smadse-glitch.github.io/testgame/

## Every session

1. Open this folder in the Claude desktop app ("Code" tab).
2. Type `/sync`: you get the latest version, a short briefing on what changed, and the game opens so you can play it.
3. Build with Claude, playing as you go. If you disagree with something the other person made, change it and tell Claude why.
4. Type `/save` after each working change and before you stop. Claude writes the log entry and shares your work.

## Commands

| Command | What it does |
| --- | --- |
| `/sync` | Get the latest, hear what changed, play it |
| `/save` | Check the game starts, write the log, share your work |
| `/decide` | Write down a decision and why |
| `/status` | Where am I? (changes nothing) |
| `/what-broke` | Find which change broke something |
| `/undo` | Take back a change, or go back to a good version |
| `/experiment` | Try something risky on the side |
| `/fix-conflict` | Sort out two edits that clash |
| `/milestone` | Mark a version we're happy with |
| `/recap` | Summary since the last check-in |

You can also just ask in plain words ("save my work", "what did they change?").

## Where things are

- `docs/status/`: where each of us left off (one file per person)
- `docs/PLAN.md`: the plan we agreed on
- `docs/log/`: what happened, session by session
- `docs/decisions/`: why things are the way they are
- `CLAUDE.md`: the rules every Claude session follows
- `SETUP.md`: first-time setup

## If something goes wrong

Nothing is ever lost: the history keeps every version. Ask Claude for `/status` to see where you are, `/what-broke` to find the cause, and `/undo` to take a change back.
