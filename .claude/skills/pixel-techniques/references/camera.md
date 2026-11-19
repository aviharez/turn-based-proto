# Camera

Source: https://www.spritecook.ai/blog/2d-camera-follow-dead-zone-look-ahead

Eight modes: locked, smooth, dead zone, room-by-room, look-ahead, points of interest,
aim offset, two targets. Numbers below are for a 128 px view at 60 ticks/s.

- Smooth: rate 2.6/s, use `1 - exp(-rate*dt)` (frame-rate independent).
- Dead zone: +-22 px h, +-18 px v (Camera2D drag margins 22/64, 18/64).
- Room slide: 0.55 s smoothstep.
- Look-ahead: 32 px lead, 3.4/s.
- Points of interest: 0.6 pull, weighted 60 px -> 24 px, 3.5/s.
- Two targets: 104 px padding, zoom clamped.

## Our use
- Expedition floors (7x9 grid fits the screen): **room-by-room**, mostly static; slide 0.55 s
  only when a floor is larger than the screen.
- Settlement: **smooth + dead zone** while walking; **points of interest** pull toward
  buildings with a ready job (crop harvest, ally quest).
- Boss intro: brief POI lean toward the boss.

## Pitfalls
Smooth cameras land between pixels -> shimmer: snap camera and hero to whole pixels.
Space POIs beyond pull distance. Shake is an offset, never overwrite position.
Camera process callback = Physics, after the player moves.
