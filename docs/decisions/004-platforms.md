# 004 · Browser first, iPhone later, no Android

- **Date:** 2026-11-11
- **Decided by:** Sune and Maik
- **Status:** Accepted

## Question

Which platforms do we build for?

## Options considered

- **Learning game as a native iPhone app:** rehearses the real pipeline, but needs Xcode and app signing from day one.
- **Learning game as a web page:** a link anyone can open on Mac or iPhone, with no Apple account needed.
- **Android:** neither of us uses it.

## Decision

- **Learning game:** a web build at a playable link. One native iPhone build at the end, as a stretch goal, to rehearse the pipeline.
- **Real game:** a native iPhone app, possibly Mac or Windows for Steam. Decided at the concept stage.
- **Android:** out of scope for both games.

## Why

Day to day we play inside the Godot editor on our Macs either way; the export is only the last step, so the workflow is the same for both games. A link is the lowest-friction way to share builds.

## Revisit if

The real game's audience is mainly on Android, or iPhone Safari keeps failing to run the web build.
