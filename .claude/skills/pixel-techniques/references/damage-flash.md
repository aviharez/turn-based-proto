# Damage-taken and status visuals (from i-frames techniques)

Source: https://www.spritecook.ai/blog/invincibility-frames-2d-blink-flash

Real-time i-frames don't apply to a turn-based game, but the 13 visual looks are our
vocabulary for status effects and damage states.

## Variants and our mapping
blink (4 on/4 off) -> "Guarding" stance pulse (slow)
see-through 45% alpha -> Blink/teleport rune afterimage
fade pulse -> Spirit form / invisible status
flash red -> damage taken (hero)
flash white -> damage dealt (see hit-feedback)
dark flicker -> Blight/curse status
rainbow -> legendary pickup moment only
jitter +-1 px -> stunned
squash pulse -> NOT used (no scaling pixel sprites)
outline ring -> targeted by an enemy intent this turn
echo ring -> Echo rune trigger
shield bubble -> Ward / barrier status
sparkles -> healed / buffed

## Implementation rules from the article
- One child node per unit owns the look; save sprite state (visibility, modulate, offset,
  scale, material) before applying, restore every tick.
- Use a canvas_item shader for tints and outlines. Never swap animation frames.
- Flips faster than ~4 ticks are unreadable.
