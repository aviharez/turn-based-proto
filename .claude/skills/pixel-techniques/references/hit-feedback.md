# Hit feedback (adapted to turn-based)

Source: https://www.spritecook.ai/blog/hit-stop-hit-flash-knockback-screen-shake

All effects fire from one `hit()` call on the contact tick. In our game the sim resolves the
hit instantly; the VIEW plays these effects when animating the `Damaged` event.

| Effect | Article numbers | Our adaptation |
| --- | --- | --- |
| Hit stop | both fighters freeze 5 ticks (9 on kill) | same; only the two units freeze |
| Hit flash | target pure white 2 frames via shader (not modulate) | same |
| Knockback | 12 px over 8 ticks, ease-out 1-(1-t)^3, after freeze | only when a Push/Pull rune moves the unit a tile: animate the full tile move with this curve |
| Screen shake | 3 px over 10 ticks, quadratic falloff, whole-pixel alternating offsets | crits, boss hits and kills only |
| Particles | 10 pieces (28 on kill), 90-200 px/s, ~0.26 s, 2-3 px | element-coloured from the palette |
| Impact spark | 4-ray star 4 frames, rays 5/9/7/3 px | melee hits |
| Slash trail | arc over last 100 deg, held through freeze, shrinks 6 ticks | melee and Parry |
| Damage number | Label alive 46 ticks, rises 8 px in 10 with sine hop, blinks last 6 | same; crits bigger + accent colour |
| Kill slow-mo | time_scale 0.3 for 12 ticks after freeze | last enemy of a floor and bosses only |

## Ordering
Manager first (low process_physics_priority) -> fighters freeze -> flash/spark/shake/trail keep
updating -> knockback + particles start the tick after the freeze -> slow-mo after freeze ->
numbers and sparks on top (high z_index).

## Pitfalls
time_scale 0 halts effects too; modulate can't whiten dark pixels; add shake to camera offset
and reset to exactly 0; never squash-scale pixel sprites; guard freed targets; per-unit freeze
counters for multi-hits; shorten freezes in fast multi-hit combos (Echo runes!).

## Turn pacing rule
A full enemy phase must finish in <= 0.6 s for normal floors. Enemies act in parallel; only
the hit-stop of the most important hit is shown when several land together.
