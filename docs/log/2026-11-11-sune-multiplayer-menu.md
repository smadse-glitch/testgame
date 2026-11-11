# Title screen and online two-player mode · Sune · 2026-11-11

**What changed:** The game now opens on a title screen with **Single player** and **Multiplayer**.
- Single player is the square game as before, with a **Menu** button (or Esc) back to the title.
- Multiplayer: **Host a game** gives you a 4-letter code (and, in the web version, a **Copy link** button), or type a friend's code and press **Join**.
- Lobby: host on the left (blue), guest on the right (orange). Each types a name (the other sees it as you type) and presses **Ready**. When both are ready, a 3-2-1-Go! countdown runs on both screens.
- Game: each player moves their own square; you see the other's square move live, with names above. If one leaves or the connection drops, the other gets a message and a "Back to menu" button.

**Why:** Sune wanted to try online play early, while the game is tiny, to learn how hard it is.

**Decisions:** Online multiplayer is now part of the learning game, built on `main` (not an experiment branch), through Supabase Realtime. See [decision 006](../decisions/006-online-multiplayer-with-supabase.md). This overrides "online features: out of scope" in `docs/PLAN.md`.

**How to test:**
- Two windows on one Mac: open the game twice. In one, Multiplayer → Host. In the other, Multiplayer → type the code → Join. Type names, press Ready in both, and move the squares.
- Two machines: host on the playable link, send the copied link to the other player.
- Wrong code: Join with a made-up code. After about 6 seconds it says no game was found.

**Known issues / half-done:**
- Squares can overlap; there's no game yet, just moving.
- If the Supabase project has paused after a week unused, multiplayer says it lost the connection. Wake it in the Supabase dashboard.
- The guest briefly sees "Looking for the host…" even with a correct code; it switches within a second.

**Files:** `project.godot` (start screen, `Net` autoload, bigger UI text), `scripts/autoload/net.gd` (new), `scenes/ui/` and `scripts/ui/` (title, multiplayer menu, lobby, all new), `scenes/multiplayer_game.tscn` and `scripts/multiplayer_game.gd` (new), `scenes/main.tscn` and `scripts/main.gd` (Menu button), `assets/ui_theme.tres` (new), `docs/decisions/006-…` (new).

**Cards:** None
