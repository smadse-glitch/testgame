# Game Dev Plan: Learning Project & Foundation

_The approved plan, 2026-11-11. Where a decision record in `docs/decisions/` says something newer, the decision record wins._

## The big picture

We build one small game first to learn how to collaborate, then reuse the same engine, repo setup and habits for the real game. The goal of stage 1 is a working process, not a great game.

**The aspiration.** A real game on the App Store or Steam. We both use Macs and iPhones, so iPhone is the natural mobile target and Android is out of scope. Genre and scope are deliberately undecided. It is a hobby: we work on it when we have time, with no deadlines.

**Two stages.**

1. **Learning project.** A tiny browser game with flexible requirements. It is done when the practice checklist is done, however long that takes. We practise every step we will need later: syncing, logging, fixing conflicts, undoing mistakes, tracking work and publishing a build.
2. **The real project.** Brainstorm and scope first, then a small playable prototype, then the full build and the App Store or Steam.

**How we work.**

- **Claude writes the code; we make the decisions.** We describe what we want, play the result, and say what to change. Neither of us needs to read code.
- **We judge by playing, not by reading.**
- **Everyone works from the latest version.** Each session starts by pulling and playing what the other person did. If you disagree, change it and say why. There is no approval gate.
- **Claude documents everything.** Every change and decision is written into the repo, so the other person always has full context, especially when something breaks.
- **The rules live in the repo.** `CLAUDE.md` tells every Claude session how we work, so both our Claudes follow the same process.
- **Nothing in stage 1 blocks stage 2.** Same engine, same tools, same workflow; only the game and the export target change.

## Foundation choices

We use the Godot engine for both games, because it publishes to the web, iPhone and Steam, and its files are plain text that Claude and GitHub handle well. A browser game first does not change the process for the real game: day to day we play inside the Godot editor on our Macs either way, and the export is only the last step.

| Area | Choice | Why | Main alternative |
| --- | --- | --- | --- |
| Game engine | Godot 4, pinned at 4.7.2 | Free and open source, no royalties. Exports to web, iOS, macOS and Windows (Steam). Scenes and scripts are text files, so Claude can edit them and GitHub can combine changes. | Unity: bigger ecosystem, but heavier, and its scene files are harder for AI and for merging. |
| Language | GDScript | Godot's own language; Claude writes it fluently. C# can't export to the web and is still experimental on iOS. | C# |
| Style | 2D to start | Fastest to build, easiest to judge by eye. Stylized 3D stays possible later. | 3D |
| AI coding | Claude Code in the Claude desktop app ("Code" tab), each on our own plan | No terminal needed. Included in the Pro and Max plans. | Claude Code in a terminal or VS Code |
| Code home | One shared GitHub repo; we both push to `main` | Simplest setup for two people; the history lets us undo anything. | Branches and pull requests |
| Task board | GitHub Projects, linked to the repo | Free, sits next to the code, and Claude can read and update it. | Linear, Notion, Trello |
| Claude runs the game (optional, once the basics work) | Godot MCP server | Lets Claude launch the game and read its errors itself, so it catches crashes before we play. | Copy-paste errors to Claude |
| Builds | Learning game: web link. Real game: native iPhone app, maybe Mac/Windows for Steam | A link needs no Xcode or Apple account. iOS export needs a Mac with Xcode, which we both have. | Android: out of scope for both games |

## Godot: limitations to know

None of these block a 2D or stylized game on iPhone or Steam. Two shape how we work day to day; three only matter if the real game's concept goes in a particular direction.

| Limitation | What it means for us | How we handle it |
| --- | --- | --- |
| AI sometimes writes old Godot 3 code | Models mix Godot 3 and 4 syntax because the web is full of Godot 3 tutorials. It shows up as errors when the game runs. | `CLAUDE.md` pins Godot 4 and lists the common traps; the start check and the Godot MCP server catch the rest. |
| Web builds can be shaky on iPhone Safari | Forum reports of crashes and audio or memory problems in recent 4.x web exports on iOS. The engine alone is about 40 MB before compression. | Learning game: play mainly in the Mac browser, test the iPhone link early, keep assets small. The real game ships as a native app. |
| Store features need plugins | In-app purchases and Game Center come through official iOS plugins whose docs lag behind the engine. Ads rely on community plugins. | Fine for a paid or simple free game. If the concept is ad-funded free-to-play, test the plugins before building. |
| High-end 3D | Good for stylized or low-poly 3D; behind Unity and Unreal for realistic, detailed 3D. | Choose 2D or stylized 3D, or rethink the engine at the concept stage. |
| Consoles | No built-in console export; consoles go through third-party porting. | Out of scope for us. |
| Smaller ecosystem | Fewer ready-made assets, tools and tutorials than Unity. | Free asset packs; Claude writes most systems anyway. |

**Checkpoint:** we confirm the engine when we write the real game's one-page concept. If that concept needs realistic 3D, consoles or heavy ad monetisation, we look at Unity before building.

## How we work: GitHub + Claude

We both work directly on `main` and keep it runnable. Every session starts by pulling and playing the latest version, and ends by pushing a working change with a log entry. There is no approval step: if you disagree with something, you change it in your next session and log why.

**The session loop:** `/sync` (get the latest) → catch up (read the log, play it) → disagree? Adjust it and log why → build and play with Claude → `/save` (log, commit, push) → `main` on GitHub → the next `/sync`. Either of us can run this loop at any time; `main` on GitHub is where our work meets.

### Why `main`, not branches

Branches and pull requests protect a shared version from unreviewed changes. With two people, no launch and no approval step, they mostly add steps.

- **Simpler:** no branches, pull requests or merges to learn, and nothing waits on the other person.
- **The cost:** a broken push breaks the game for the other person. Three safeguards cover it: a git hook refuses any push where the game doesn't start (whoever pushes), every push is logged, and `/undo` reverts any change in one step.
- **Working at the same time still works:** if we both push around the same time, the second `/save` pulls first and combines the work. Edits to the very same lines conflict either way, branches or not.
- **Branches stay available** for risky experiments (`/experiment`). If we keep tripping over each other, switching to branches and pull requests is a small change to `CLAUDE.md` and the commands.

The golden rules, the shared commands and the guardrails are in `CLAUDE.md`, `.claude/skills/` and `.claude/settings.json`. The repo-hygiene choices made after review (per-person status, Git LFS, the pre-push check, hotspot files, protecting `main`) are in decision 005.

## Documentation: full context for both of us

Claude writes every change and decision into the repo, because each of our Claude chats is private; only what is in the repo is shared. No push without a log entry.

| What | Where | Written | Holds |
| --- | --- | --- | --- |
| Session log | `docs/log/`, one file per session | Every `/save` | What changed as a player would notice it, why, decisions made, how to test it, what's half-done or broken, files touched, a screenshot |
| Decision records | `docs/decisions/` | `/decide`, or when Claude spots a decision in chat | The question, the options, what we chose and why, who decided |
| Where each of us left off | `docs/status/<name>.md`, one file per person | Every `/save` | What I'm working on, which shared files I've claimed, what's half-done, my next step |
| Shared facts | GitHub: tags, issues, the board | As they happen | The last good version, open bugs, who's on what |
| Commit messages | Git history | Every commit | A detailed what and why, pointing to the log entry |
| Bugs | GitHub issues labelled "bug" | When found | Steps to reproduce, what should happen, which log entry it appeared after |

**When something fails,** `/what-broke` reads the logs since the last good version, lines them up with the history, and names the change most likely responsible. Undoing it is one `/undo`, which is logged too. **Reading it is built in:** `/sync` turns every new log entry into a short briefing at the start of a session.

## Seeing it, not reading it

- **Play the latest first.** `/sync` opens the game; the first thing you do in a session is play what changed.
- **Every log entry carries a picture** when it helps: a screenshot or short screen recording.
- **A playable link that is always current.** Every push updates the web build.
- **Mock up before building.** For anything with a look (menus, score display, art style), ask Claude for a quick visual mockup first, agree on it, then build.
- **Tune by feel, not by code.** Tunable numbers are editable values in Godot's Inspector: drag a value, press Play, feel the difference.
- **Show the invisible.** Godot's Debug menu can draw hitboxes.
- **iPhone check at each milestone.** Open the link in Safari on our iPhones; web builds can behave differently there.
- **Let Claude play first.** With the Godot MCP server, Claude can run the game and read crash messages itself.

## Project management

One GitHub Projects board shows all work, the session logs carry the detail, and we check in whenever it suits us. What matters is the loop, not the calendar.

| Column | Means |
| --- | --- |
| Ideas | Anything goes, no commitment. |
| Backlog | Shaped tasks, ready for anyone to pick. |
| Next up | What each of us intends to pick up next. |
| In progress | Someone is on it; the card names who and which scene. |
| Done | Pushed to `main` and logged. |

Each card is a GitHub issue with a short title, "what good looks like" in 1–3 lines, an owner and a label: feature, bug, art, sound or process. Cards that feel big get split.

**Checking in,** whenever we get together: play the latest `main` together; go through `/recap` (what changed, what's stuck, what we disagreed on); pick what's next; make one process fix. `/recap` can post the notes on the pinned "Check-in notes" issue.

**House rules:** milestones, not deadlines. Stepping away? Unassign your cards. Disagreements are normal: change it, log why, and raise it at the next check-in if it keeps flipping back and forth. A chat ping when you push something big.

## The learning project

A small browser game that we choose together, built in Godot and published as a web link. It is done when the practice checklist is done.

**What makes a good learning game:**

- **Small:** one screen or one short level.
- **Splits in two:** at least two parts we can build in parallel without touching the same scenes. Claude helps divide it into two lanes, and we swap lanes halfway.
- **Has feel to tune:** speed, difficulty or timing we judge by playing.
- **Works with keyboard and touch,** so it plays on the Mac and on the iPhone link.
- **Simple art:** shapes or free assets.
- **Fun enough** that we want to finish it.

**Out of scope:** online features, ads and purchases, Android, publishing to a store.

**Practice exercises** (each rehearses something the real project will need):

- [ ] **First loop:** each of us pushes a tiny logged change.
- [ ] **Catch-up:** start a session by playing the other's latest change, then adjust one thing and log why.
- [ ] **Same-time push:** both push around the same time; the second `/save` combines the work.
- [ ] **Planned conflict:** both change the same line of text without syncing, then resolve it with `/fix-conflict`.
- [ ] **Break and recover:** push something that breaks the game on purpose, find it with `/what-broke`, undo it with `/undo`.
- [ ] **Experiment:** try a risky idea on an experiment branch, then merge it or throw it away.
- [ ] **Decision record:** settle one real design question with `/decide`.
- [ ] **Hand-over:** one of us finishes a task the other started, working only from the log.
- [ ] **Change of plan:** add a surprise feature request and re-plan it at a check-in.
- [ ] **Release:** `/milestone` v1.0, with release notes and the playable link.
- [ ] **Stretch: native iPhone build.** Export to Xcode and install on our own iPhones with a free Apple ID (apps signed this way stop opening after 7 days until rebuilt). This rehearses the real game's pipeline.

## Phased plan

Six phases, each ending in a gate we check by playing. No dates: a phase is done when its gate is met.

| Phase | What | Gate |
| --- | --- | --- |
| 0 · Tools | Each of us: GitHub account, Claude Pro/Max with the desktop app, Godot 4.7.2, Git, GitHub CLI, Git LFS (`SETUP.md` part 0) | Tools installed |
| 1 · Kickoff | Owner sets up the repo, board and playable link (`SETUP.md` part A); partner joins (part B); we choose the game | Both run the same game from `main`, and the link opens on both iPhones |
| 2 · First loops | "First loop" and "catch-up" exercises, one small card each, first check-in | Each of us has pushed a logged change the other has played |
| 3 · Build | Two lanes; the conflict, break-and-recover, experiment, decision and hand-over exercises; add the Godot MCP server; swap lanes halfway | v0.5: the core of the game playable from the link |
| 4 · Polish and ship | Sound, screens, the change of plan, v1.0 milestone, the stretch iPhone build | v1.0 tagged and playable on both iPhones |
| 5 · Retro | What to keep and change; update `CLAUDE.md` and the commands; mark the repo as a GitHub template | A template repo we trust |

## After the learning project: the real game

The real project starts with design, not building, in a new repo made from our template, with the same board, loop and logs.

1. **Brainstorm.** Each of us brings three games we love and why. Claude helps generate concepts; we score each on fun, originality, platform fit and whether two hobbyists can finish it.
2. **Find the fun.** Grey-box prototypes of the core moment of play for the top one or two ideas. If it isn't fun with boxes, it won't be fun with art.
3. **One-page concept.** Pitch line, core loop, target platform, art style, first-release feature list and an explicit "not doing" list. This is also where we confirm Godot.
4. **Vertical slice.** One level or run that looks and plays like the final game, on the target device.
5. **Production, playtests, launch.** Milestones on the board, friends testing through TestFlight or a Steam playtest.

The biggest risk for a hobby team is scope, so we aim for a first release small enough that we will actually finish it.

| | App Store (iPhone) | Steam |
| --- | --- | --- |
| Controls and sessions | Touch, short sessions | Keyboard, mouse or controller, longer sessions |
| Store fee | Apple Developer Program, $99/year | $100 per game, returned after $1,000 in revenue |
| Testing on our own devices | Free Apple ID builds expire after 7 days; TestFlight needs the paid program | Mac builds run directly; most Steam players use Windows, so we'd want a Windows PC to test on |
| Extra hurdles | Apple's app review before each release | Store page public as "Coming Soon" at least two weeks before release |

## Costs

| Item | Cost (USD) | When |
| --- | --- | --- |
| Claude Pro, each of us | $20/month, or $17/month billed yearly; Max if we keep hitting limits | Now |
| Godot | Free | Now |
| GitHub | Free, including 10 GiB of Git LFS storage and bandwidth. A public repo also gets free hosting for the playable link (GitHub Pages) and free protection of `main`; a private repo uses itch.io for the link, and protecting `main` needs GitHub Pro (about $4/month) | Now |
| Native builds on our own iPhones | Free with a normal Apple ID (rebuild every 7 days) | Stretch goal |
| Apple Developer Program | $99/year, for TestFlight and the App Store | Real game, when we want to share builds or publish |
| Steam | $100 per game | Only if the real game goes to Steam |

## Sources

- [Godot release news](https://godotengine.org/news/release), [Godot 4.7.2 maintenance release](https://gamedev.net/news/5170-maintenance-release-godot-472/)
- [Godot docs: Exporting for iOS](https://docs.godotengine.org/learning/workflow/export/exporting_for_ios.html) and [Plugins for iOS](https://docs.godotengine.org/uk/4.5/tutorials/platform/ios/plugins_for_ios.html)
- [Godot web export and hosting](https://dev.to/ziva/how-to-export-a-godot-game-to-the-web-and-share-a-playable-link-2g88), [web hosts compared](https://ziva.sh/blogs/godot-web-export)
- Godot web builds on iOS: [crash reports](https://forum.godotengine.org/t/game-crashes-randomly-on-ios-devices-html-export/114043), [WebGL context loss](https://forum.godotengine.org/t/webgl-context-loss-and-app-crash-in-godot-4-3-exported-web-on-ios-browsers/81024)
- [AI and Godot 3 vs 4 syntax](https://dev.to/ziva/7-godot-4-api-calls-your-ai-assistant-still-gets-wrong-3ep6)
- Godot strengths and limits: [3D and ecosystem](https://gamedesignskills.com/game-design/is-godot-good/), [consoles](https://gamefromscratch.com/godot-vs-unity-which-to-choose-in-2025/)
- [Godot MCP server](https://github.com/Coding-Solo/godot-mcp)
- [Claude Code with Pro or Max plans](https://support.claude.com/en/articles/11145838-use-claude-code-with-your-pro-or-max-plan.md), [Claude Code permissions](https://code.claude.com/docs/en/permissions.md)
- [GitHub plans](https://docs.github.com/en/get-started/learning-about-github/githubs-plans)
- [Testing on your own iPhone](https://newly.app/guides/test-on-your-own-phone), [app store fees](https://axonbuild.com/blog/cost-to-publish-an-app-to-the-app-stores/), [Steam fee calculator](https://www.steampageanalyzer.com/tools/steam-fee-calculator), [Steam release rules](https://www.summerengine.com/make-great-games/make-money-from-your-indie-game)
