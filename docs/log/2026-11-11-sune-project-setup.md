# Project setup · Sune · 2026-11-11

**What changed:** The project now exists on GitHub and is playable in the browser at https://smadse-glitch.github.io/testgame/. It holds the starter kit and a placeholder scene: a blue square you move with the arrow keys or by clicking/dragging.

**Why:** This is the foundation for both games: shared rules for Claude (`CLAUDE.md`), the commands (`/sync`, `/save` and the rest), the docs folders, the git hooks and the web build.

**Decisions:** Team is Sune and Maik (GitHub: pelket). Language is English. The repo is public (`smadse-glitch/testgame`), so the playable link uses GitHub Pages and `main` is protected for free. The game name isn't decided yet, so it stays `[GAME NAME]`.

**Setup done (SETUP.md part A):** GitHub's auto-made README was merged in and replaced by ours. Labels `feature`, `bug`, `art`, `sound`, `process` created. Maik already had write access, so no invite was needed. Board "testgame board" (project 1) created, linked to the repo, shared with Maik, Status columns set to Ideas, Backlog, Next up, In progress, Done. Ruleset "Protect main" blocks force-pushes and deleting `main`. GitHub Pages switched on (`DEPLOY_PAGES` = true). Check-in notes issue #1 created and pinned.

**How to test:** Open https://smadse-glitch.github.io/testgame/ (on an iPhone too; reload once if the first load is black), or open the project in Godot 4.7.2. A blue square appears; move it with the arrow keys or by clicking where it should go.

**Known issues / half-done:** The board's view still needs switching to "Board" by hand in the browser. Maik still needs to do SETUP.md part B. Part C (done check together) is still open.

**Files:** `CLAUDE.md`, `README.md`, `docs/decisions/001`-`005` (names filled in), `docs/status/sune.md` (new), this log.

**Cards:** #1 (Check-in notes)
