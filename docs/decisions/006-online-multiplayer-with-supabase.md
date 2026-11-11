# 006 · Online multiplayer in the learning game, through Supabase

- **Date:** 2026-11-11
- **Decided by:** Sune
- **Status:** Accepted

## Question

Should the learning game have online two-player mode now, and if so, how do two players connect?

`docs/PLAN.md` listed "online features" as out of scope for the learning game, and `CLAUDE.md` says big or risky ideas go on an experiment branch. This record changes both for this feature.

## Options considered

- **Experiment branch first, or leave online out:** safer, and it follows the plan. But the game is still only a placeholder, so there is nothing on `main` to protect yet.
- **Build it on `main` now:** we find out early how hard online play is, while the game is tiny. Multiplayer is much harder to add later than to build in from the start.

How players connect (the web game can't connect two browsers directly, and GitHub Pages can't run a server):

- **Supabase Realtime** (chosen): Sune already has an account. It passes messages between players in a "room", so there is no server of our own to write or run. Free projects pause after about a week without use.
- **Cloudflare Workers:** never pauses and gives full control, but needs a new account and a small server in JavaScript to look after.
- **A public test service with no account:** no setup, but anyone can see or spam messages and it can vanish. Throwaway only.
- **Netlify:** can't keep a connection open, so it can't carry a live game.

## Decision

Online two-player mode is part of the learning game, built straight on `main`:

- Title screen: Single player or Multiplayer.
- Multiplayer: Host (gets a 4-letter code, and in the web version a link) or Join (type the code).
- Lobby: the host is on the left, the guest on the right. Each types a name and presses Ready. When both are ready, there is a 3-2-1 countdown and the game starts.

Players connect through **Supabase Realtime Broadcast** on Sune's Supabase project `lcqtjcsnrauzacierbqt`. The game code is the room name. The host's game is in charge.

## Why

Sune wanted to learn what online play costs in effort and complexity now, while the game is just squares. Supabase was the option with the least new setup.

## Good to know

- The game contains Supabase's **publishable** key (`scripts/autoload/net.gd`). It is meant to be public, because it ships inside the web game anyway. The **secret** key must never go in the repo.
- Free Supabase projects pause after about a week without use. If online play stops working after a break, Sune wakes the project in the Supabase dashboard.
- Testing online play needs two game windows (or two devices).
- Every new feature now has to work in single player and in multiplayer.

## Revisit if

- Supabase's free limits or the pausing get in the way.
- Syncing makes ordinary features too slow to build.
- Maik disagrees with online play being part of the learning game.
