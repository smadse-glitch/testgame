# SETUP: from this folder to a shared, playable game

**How to use this file:** open this folder in the Claude desktop app ("Code" tab) and say: _"Follow SETUP.md, part A"_ (the repo owner) or _"part B"_ (the partner). Leave the desktop app's **Worktree** option off (it is off by default): we work in the project folder itself.

**Claude:** do the steps in order, one at a time. Before each step, say in one line what you're about to do. Ask before anything that creates something on GitHub, sends an invitation, or installs software. Things only the person can do (logging in, accepting invitations, typing a password) are marked **You**.

- **Owner:** the one who creates the repo. Only the owner needs this folder; the partner gets everything by downloading the repo.
- **Partner:** the other one.

---

## Part 0 · Tools (each of us, before starting)

- [ ] **You:** a GitHub account. An existing personal one is fine.
- [ ] **You:** a Claude Pro or Max plan, and the Claude desktop app with the "Code" tab working.
- [ ] **Godot 4.7.2, exactly** (the standard version, not .NET) in your Applications folder. Claude can download it from Godot's GitHub releases (`Godot_v4.7.2-stable_macos.universal.zip`). Check: `/Applications/Godot.app/Contents/MacOS/Godot --version` prints `4.7.2.stable…`. Both of us must use the same version: a different one rewrites project files.
- [ ] **Git.** Check: `git --version`. If it's missing, macOS offers to install Apple's command line tools: **You** click Install.
- [ ] **Homebrew** (makes the next two one-liners). Check: `brew --version`. If it's missing, Claude asks before installing it with the one command from brew.sh; **You** type your Mac password when asked.
- [ ] **GitHub CLI:** `brew install gh`. Check: `gh --version`.
- [ ] **Git LFS** (stores images and audio): `brew install git-lfs`, then `git lfs install --skip-repo`. Check: `git lfs version`.

---

## Part A · Owner, with Claude

**A1 · Fill in the blanks.** Ask for:

- both first names
- the partner's GitHub username
- the game's name, or "not decided yet" (then keep `[GAME NAME]` for now)
- the language for logs and decisions (English or Danish)
- public or private repo:
  - **Public:** free playable link on GitHub Pages, and free protection of `main` against force-pushes and deletion.
  - **Private:** the playable link goes on itch.io (part E), and protecting `main` needs the owner on GitHub Pro (about $4/month). Without it, the protection is the hooks and Claude's settings only.
- a repo name (suggest lowercase with dashes, e.g. `our-first-game`)

Then replace `[PERSON A]`, `[PERSON B]`, `[GAME NAME]` and the language line in `CLAUDE.md`, `README.md`, `project.godot` and `docs/decisions/*.md`. Create the owner's status file, `docs/status/<first name>.md`, from `docs/status/TEMPLATE.md`.

**A2 · Log in to GitHub.**
`gh auth login --web --git-protocol https --scopes project`. **You** confirm the code in the browser. Then `gh auth setup-git`, so git can push.

**A3 · Git identity.** Use the first name, and GitHub's private no-reply address so no personal or work email ends up in the history:

```
gh api user --jq '"\(.id)+\(.login)@users.noreply.github.com"'
git config --global user.name "<first name>"
git config --global user.email "<the address above>"
git config --global pull.rebase false
git config --global init.defaultBranch main
```

**A4 · First run.**
`<godot> --headless --path . --import`, then the start check from `CLAUDE.md`. Then open the game in a window: **You** should see a blue square you can move with the arrow keys or by dragging.

**A5 · First log entry, hooks and commit.** Write `docs/log/<today>-<name>-project-setup.md` from the template (what: the starter kit and placeholder scene; why: the foundation for both games). Then:

```
git init
chmod +x .githooks/*
git config core.hooksPath .githooks
git add -A
git update-index --chmod=+x .githooks/pre-push .githooks/post-checkout .githooks/post-commit .githooks/post-merge
git commit -m "Starter kit: rules, commands, docs and a placeholder scene"
```

Check: `git ls-files -s .githooks` shows `100755` for every hook.

**A6 · Create the repo on GitHub.**
`gh repo create <repo-name> --private` (or `--public`) `--source . --remote origin --push`. The `pre-push` hook runs the start check for the first time here.

**A7 · Labels.**

```
gh label create feature --color 1d76db --force
gh label create bug --color d73a4a --force
gh label create art --color fbca04 --force
gh label create sound --color 0e8a16 --force
gh label create process --color 5319e7 --force
```

**A8 · Invite the partner** (ask first): `gh api -X PUT repos/<owner>/<repo>/collaborators/<partner-username> -f permission=push`. Tell the partner to watch for an email from GitHub.

**A9 · Project board.**
`gh project create --owner @me --title "<Game name> board"`, note its number, then `gh project link <number> --owner @me --repo <owner>/<repo>`.
Then **You** open the board in the browser (`gh project view <number> --owner @me --web`), and Claude guides you click by click to:

- rename the Status options to **Ideas, Backlog, Next up, In progress, Done**
- switch the view to **Board**
- share the board with the partner

**A10 · Protect `main`** against force-pushes and deletion. Direct pushes stay allowed, which is how we work. Ask first, then:

```
gh api -X POST repos/<owner>/<repo>/rulesets --input - <<'EOF'
{
  "name": "Protect main",
  "target": "branch",
  "enforcement": "active",
  "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
  "rules": [ { "type": "non_fast_forward" }, { "type": "deletion" } ]
}
EOF
```

On a private repo without GitHub Pro, GitHub answers that it needs an upgrade. Then tell the owner the choice (GitHub Pro, or rely on the hooks and Claude's settings), and record it with `/decide`.

**A11 · Playable link.**

- **Public repo:**
  ```
  gh api -X POST repos/<owner>/<repo>/pages -f build_type=workflow
  gh variable set DEPLOY_PAGES --body true
  gh workflow run web-build.yml
  gh run watch
  ```
  The link is `https://<owner>.github.io/<repo>/`. Put it in `CLAUDE.md` and `README.md`, and run `gh repo edit --homepage <link>`.
- **Private repo:** the build still runs on every push as a check. Set up the link with part E.

**You:** open the link in Safari on your iPhone. If it shows a black screen the first time, reload once.

**A12 · Check-in notes.**
`gh issue create --title "Check-in notes" --label process --body "Notes from our check-ins. /recap posts here."`, then `gh issue pin <number>`.

**A13 · Save.** Run `/save`, so the filled-in link and your status file are shared.

---

## Part B · Partner, with Claude

**B1 · You:** accept the invitation from the email GitHub sent, or at `https://github.com/<owner>/<repo>/invitations`.

**B2 · Tools and login:** part 0, then steps A2 and A3 above.

**B3 · Get the repo.** Ask where to keep it (suggest `~/Games`), then:

```
gh repo clone <owner>/<repo> ~/Games/<repo>
cd ~/Games/<repo>
git config core.hooksPath .githooks
git lfs pull
```

**You** open that folder in a new Claude Code session (Worktree off).

**B4 · Run `/sync`.** You get the briefing and the game opens.

**B5 · First loop.** Make a tiny change with Claude (for example, the square's colour, via Godot's Inspector or by asking), then `/save`. This also creates your own status file.

---

## Part C · Done check (together)

- [ ] We both run the same game from `main`, both on Godot 4.7.2.
- [ ] The playable link opens on both our iPhones.
- [ ] Each of us has pushed a logged change the other has played.
- [ ] We've chosen the learning game: record it with `/decide` (the next free number in `docs/decisions/`), then ask Claude to turn it into the first cards on the board.

---

## Part D · Optional: let Claude run the game itself

When the basics work, the Godot MCP server lets Claude launch the game and read its errors without your help. It needs Node.js (`brew install node`, with your OK).

Create `.mcp.json` in the repo root:

```json
{
  "mcpServers": {
    "godot": {
      "command": "npx",
      "args": ["-y", "@coding-solo/godot-mcp"],
      "env": { "GODOT_PATH": "/Applications/Godot.app/Contents/MacOS/Godot" }
    }
  }
}
```

Start a new session and approve the server when asked. Test it with "run the game and show me any errors". Then `/save`; the partner approves it in their own session.

---

## Part E · Only for a private repo: the link on itch.io

1. **You:** create an itch.io account and a new project. Set "Kind of project" to HTML and visibility to Draft, which gives a secret link.
2. Claude installs butler (itch's upload tool) and runs `butler login`; **You** approve in the browser.
3. Export and upload:
   ```
   mkdir -p build/web && touch build/.gdignore
   <godot> --headless --path . --export-release "Web" build/web/index.html
   butler push build/web <itch-user>/<game>:web
   ```
4. **You:** on the itch.io project page, mark the upload "This file will be played in the browser", and save.
5. Put the secret link in `CLAUDE.md` and `README.md`. From now on, `/milestone` repeats step 3.
