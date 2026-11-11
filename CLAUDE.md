# CLAUDE.md: how we work on this game

Every Claude session in this repo reads this file first. Follow it. If something here conflicts with what a person asks in the moment, point out the conflict in one line and ask before acting.

## About this project

- **Game:** Are you Square? (see `docs/decisions/` for what we've decided so far)
- **Team:** Sune and Maik. Two hobbyists who work on this whenever we have time. Neither of us reads or writes code.
- **Language:** talk to us, and write logs, decisions and commit messages, in **English**. (Change this line to switch language, e.g. to Danish.)
- **Playable link:** https://smadse-glitch.github.io/testgame/
- **The plan:** `docs/PLAN.md` holds the approved plan: why we work this way, the phases and the path to the real game. Read it when you need background. Where a decision record in `docs/decisions/` is newer, the decision record wins.

## Your role

- You write all code, scenes and configuration. We decide what to build and judge it by playing.
- Explain in plain words. When a git or Godot term is unavoidable, explain it in one short sentence the first time it comes up in a session.
- Before anything that changes shared history or is hard to undo (push, revert, merge, deleting files), say in one line what you are about to do.
- When you're unsure what we want, ask one short question rather than guessing. Don't ask about things you can check yourself.
- Keep the game runnable. `main` must never be left in a state where the game doesn't start.

## Tech facts

- **Engine:** Godot **4.7.2**, exactly. The version is pinned in `project.godot` and in `.github/workflows/web-build.yml` (`GODOT_VERSION`).
  - Opening the project in a different Godot version rewrites files. If the person's Godot isn't 4.7.2, say so before touching the project. If Godot offers to convert or upgrade the project, the answer is no.
  - Upgrading Godot is a decision: record it with `/decide`, then both of us upgrade together and change both pinned places in one push.
- **Language:** GDScript for Godot 4 only. No C#.
- **Renderer:** Compatibility (required for web builds).
- **Folders** (the Godot project is the repo root):
  - `scenes/`: `.tscn` scenes, one per thing (`player.tscn`, `ui/title_screen.tscn`)
  - `scripts/`: `.gd` scripts, named after their scene; autoloads (global scripts) in `scripts/autoload/`
  - `assets/`: `art/`, `audio/`, `fonts/`
  - `docs/`: status, logs, decisions and the plan (Godot ignores it via `docs/.gdignore`)
- **Naming:** files and folders `snake_case` (`player_ship.tscn`); nodes `PascalCase` (`PlayerShip`).
- **Git LFS:** images, audio, fonts and art source files are stored with Git LFS, as set in `.gitattributes`. Before committing any such file, check that `git lfs version` works; if it doesn't, stop and help install it (`SETUP.md`, part 0).
- **Git hooks** live in `.githooks/` and must be switched on in every copy of the repo (`git config core.hooksPath .githooks`). The `pre-push` hook runs the start check before any push, whoever pushes, and uploads LFS files.
- Godot 4.4 and later create `.uid` files next to scripts and resources. Always commit them; never delete them. Also commit Godot's `.import` files.
- Never edit or commit `.godot/` (Godot's cache) or `build/` (exports).
- Make every value we may want to tune (speed, timing, difficulty, colours, sizes) an `@export` variable with a short comment, so we can change it in Godot's Inspector without touching code.
- Prefer simple, readable code over clever code. Start each script with a comment saying in plain words what it does.
- **No worktrees.** We work in the project folder itself. If this session is running inside `.claude/worktrees/` (check with `git rev-parse --show-toplevel`), tell the person to turn off the desktop app's **Worktree** option and start a new session in the project folder.

### Godot 4, not Godot 3

Much example code online is Godot 3. Always write Godot 4. The common traps:

| Godot 3 (wrong) | Godot 4 (right) |
| --- | --- |
| `export var speed = 200` | `@export var speed := 200.0` |
| `onready var sprite = $Sprite` | `@onready var sprite := $Sprite2D` |
| `yield(get_tree().create_timer(1), "timeout")` | `await get_tree().create_timer(1.0).timeout` |
| `KinematicBody2D` | `CharacterBody2D` |
| `move_and_slide(velocity, Vector2.UP)` | set `velocity`, then `move_and_slide()` |
| `connect("pressed", self, "_on_pressed")` | `pressed.connect(_on_pressed)` |
| `scene.instance()` | `scene.instantiate()` |
| `rand_range(a, b)` | `randf_range(a, b)` / `randi_range(a, b)` |
| `deg2rad()` | `deg_to_rad()` |
| `Spatial`, `.translation` | `Node3D`, `.position` |
| `Tween` node, `interpolate_property` | `create_tween().tween_property(...)` |
| `OS.get_ticks_msec()` | `Time.get_ticks_msec()` |

### Running Godot

- On our Macs Godot is usually at `/Applications/Godot.app/Contents/MacOS/Godot`. If it isn't there, ask where it is installed. Always use the full path in commands.
- A fresh clone needs one import before anything else: `<godot> --headless --path . --import`
- **Start check:** `<godot> --headless --path . --quit-after 120`. Read the output. Any line with `SCRIPT ERROR`, `Parse Error` or `ERROR:` is a failure: fix it before pushing, or tell us plainly why you can't. The same check runs in the `pre-push` hook and on GitHub after every push.
- **Let us play:** run `<godot> --path .` in the background to open the game in a window, and tell us what to try.
- If the Godot MCP server is connected (see `SETUP.md`, part D), prefer its tools to run the game and read errors.

## The loop

Every session follows the same loop:

1. **Start:** `/sync`. Get the latest, brief the person on what changed, let them play it.
2. **Build:** make changes with the person, playing often.
3. **Share:** `/save` after each working change and always at the end. No push without a log entry.

## Golden rules

1. We work directly on `main`. `main` must always run.
2. Every session starts with `/sync`. If the person forgets, offer to run it first.
3. Disagreeing is normal. When a person wants to change the other's work, do it and record why in the log. Never silently undo someone's work.
4. Push small and often. Unpushed work is invisible to the other person.
5. **Check before you touch shared things.** Before editing a scene, read the other person's file in `docs/status/` and the open cards; if they're in the same scene, warn us first. These **hotspot files** are touched by everything, so claim them (in your own status file, and tell the person to ping the other), keep the change small, and push straight after:
   - `project.godot` (game settings, the input map, autoloads)
   - `export_presets.cfg`
   - anything in `scripts/autoload/`
   - `.gitattributes`, `.gitignore`, `.githooks/`, `.github/`
   - `CLAUDE.md` and `.claude/`
6. Never force-push, rewrite history, hard-reset, rebase, clean the working tree or skip the hooks (`--no-verify`). `.claude/settings.json` blocks these, and GitHub protects `main` where our plan allows it; don't look for workarounds (`git -C`, `sh -c`, other spellings). If git gets into a state you don't understand, stop and explain.
7. Pull with merge, never rebase: `git pull --no-rebase origin main`. If a push is rejected, pull, combine, run the start check, push again.
8. Risky or big ideas go on a branch via `/experiment`. Everything else happens on `main`.
9. **Keep the repo small.** Binary files go through Git LFS. Ask before adding any single file over 50 MB. Screenshots for the log are compressed JPEGs under 300 KB.
10. Never commit secrets: passwords, API keys, tokens.

## Documentation (non-negotiable)

Each of our Claude chats is private to one of us. Only what is in this repo is shared, so write everything down here, for a reader who wasn't there.

- **Session log:** one file per session in `docs/log/`, named `YYYY-MM-DD-<name>-<short-topic>.md`, following `docs/log/TEMPLATE.md`. If you `/save` several times in one session, update that session's file.
- **Status:** each person has their own file, `docs/status/<name>.md` (from `docs/status/TEMPLATE.md`): where they left off, what they're working on, which hotspot files they've claimed, what's half-done. Update **only the current person's** file, on every `/save`. Two people never edit the same status file, so it never clashes.
- **Shared facts come from GitHub, not a file:** the last good version is the latest tag; open bugs and who's on what are the issues and the board; running experiments are the `experiment/...` branches.
- **Decision records:** `docs/decisions/NNN-short-title.md`, via `/decide`. When you notice we've settled something in chat (a design choice, a rule, a tool), offer to record it.
- **Commit messages:** a first line that says in plain words what changed; a body with what and why; then `Log: docs/log/<file>`; then `Refs #N` or `Closes #N` for the card.
- **Bugs:** GitHub issues labelled `bug`, with steps to reproduce, what should happen, what happens, and which log entry it appeared after.

## Commands

Each command is defined in `.claude/skills/<name>/SKILL.md`. If a person asks in plain words for something a command covers ("save my work", "what changed?", "undo that"), follow that command's steps.

| Command | Use it |
| --- | --- |
| `/sync` | At the start of every session |
| `/save` | After each working change, and always at the end |
| `/decide` | When we settle something worth remembering |
| `/status` | Any time someone is unsure where things stand (changes nothing) |
| `/what-broke` | When something that worked now doesn't |
| `/undo` | To take back a pushed change, or return to a tagged version |
| `/experiment` | To try something risky on a branch |
| `/fix-conflict` | When two edits clash |
| `/milestone` | To mark a version we're happy with |
| `/recap` | When we check in together, or after a break |

## GitHub

- Use the GitHub CLI (`gh`) for issues, the board and releases. If it isn't logged in, help the person run `gh auth login`.
- **Board:** a GitHub Projects board with the columns Ideas, Backlog, Next up, In progress, Done. Each card is an issue.
- **Labels:** `feature`, `bug`, `art`, `sound`, `process`.
- **Protecting `main`:** when the repo allows it (public, or a paid GitHub plan), a ruleset blocks force-pushes to `main` and deleting it. Direct pushes stay allowed.
- **Web build:** every push to `main` runs `.github/workflows/web-build.yml`. It checks that the game starts, exports the web build and, when the repo variable `DEPLOY_PAGES` is `true`, publishes it to the playable link. If a build fails, GitHub emails us; inspect it with `gh run list` and `gh run view <id> --log-failed`, and fix it.
