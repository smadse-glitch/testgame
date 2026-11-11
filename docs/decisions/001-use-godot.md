# 001 · Use Godot for both games

- **Date:** 2026-11-11
- **Decided by:** Sune and Maik
- **Status:** Accepted

## Question

Which game engine do we use for the learning game and the real game?

## Options considered

- **Godot 4:** free, open source, no royalties. Exports to web, iOS, macOS and Windows. Scenes and scripts are plain text, which Claude and git handle well.
- **Unity:** bigger ecosystem and more mobile games shipped with it, but heavier, and its scene files are harder for AI to edit and for git to combine.
- **A web-only stack:** fine for a browser game, but would mean a second set of tools for the real game.

## Decision

Godot 4 (pinned at 4.7.2), GDScript only, 2D to start. The same engine for both games.

## Why

One engine means everything we learn in the learning game carries over. Text-based project files suit a workflow where Claude writes the code and two people share one repo.

Known limits we accept:

- AI tools sometimes write old Godot 3 code. `CLAUDE.md` lists the traps, and the start check catches the rest.
- Godot web builds have a history of problems in iPhone Safari. The real game ships as a native app.
- In-app purchases and Game Center need plugins. High-end 3D and consoles are weaker spots.

## Revisit if

The real game's concept needs realistic 3D, consoles, or heavy ad-funded free-to-play monetisation. We check this when we write the real game's one-page concept.
