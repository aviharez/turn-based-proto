# Input forgiveness for touch (from platformer coyote time/buffering)

Source: https://www.spritecook.ai/blog/coyote-time-jump-buffering-corner-correction

Platformer numbers (for reference): coyote 0.1 s, jump buffer 0.1 s, corner correction up to
1/8 tile. Count physics ticks, not frames.

## Principles we apply to a turn-based touch game
- **Input buffering:** a tap during an animation or enemy phase is stored and executed when
  input is accepted again. Max 1 buffered action; show it as a ghost highlight.
- **Touch forgiveness:** hit areas slightly larger than tiles; a tap near a tile edge snaps
  to the nearest VALID tile within a small radius - never to an invalid one.
- **Confirm only when it matters:** single tap = move/attack; irreversible actions (consuming a
  rare item, leaving with unbanked loot) need a second tap.
- **Windows in turns/animation states, not seconds.**
- **Clear buffers** on cancel, menu open/close, floor change.
- **Undo last move** if no enemy has acted yet and no randomness was revealed (big quality-of-life win).
