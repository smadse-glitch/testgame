# docs

Everything a person needs to catch up without asking. Claude writes these; we read them, or let `/sync`, `/status` and `/recap` brief us.

| Where | What |
| --- | --- |
| `status/<name>.md` | Where each of us left off: what we're working on, which shared files we've claimed, what's half-done. One file per person, so they never clash. |
| `log/` | One file per work session: what changed, why, how to test it, what's half-done. |
| `decisions/` | One file per decision: the options, what we chose, and why. |
| `PLAN.md` | The plan we agreed on: how we work, the phases, the path to the real game. |

Shared facts aren't kept in a file both of us edit; Claude reads them from GitHub instead:

- **Last good version:** the latest tag (`/milestone`)
- **Open bugs and who's on what:** the issues and the board
- **Experiments:** branches named `experiment/...`

Godot ignores this folder (`.gdignore`), so screenshots in `log/img/` don't end up in the game.
