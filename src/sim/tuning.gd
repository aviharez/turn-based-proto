class_name Tuning
extends RefCounted
## Global balance constants that are not per-content data.
## Per-unit, per-rune and per-enemy values belong in src/content/*.json.
## Every value here is specified (with its safe range) in design/gdd/battle.md §7.

# ---------- Arena ----------
## Walkable battle arena size in tiles (inside the 9-tile-wide battle view).
const ARENA_WIDTH: int = 7
const ARENA_HEIGHT: int = 8
## Highest tile elevation (0 = ground, 1 = terrace).
const ELEVATION_MAX: int = 1

# ---------- Focus ----------
## Most Focus the hero can hold.
const FOCUS_MAX: int = 6
## Focus at battle start.
const FOCUS_START: int = 2
## Focus gained at the start of each player phase from round 2 on.
const FOCUS_PER_TURN: int = 1
## Focus gained when a Strike hits.
const FOCUS_ON_STRIKE_HIT: int = 1
## Focus refunded when a Parry cancels a hit.
const FOCUS_ON_PARRY: int = 1

# ---------- Action costs ----------
const STRIKE_COST: int = 0
const GUARD_COST: int = 1
const PARRY_COST: int = 2

# ---------- Guard / Parry ----------
## Percent of each hit removed while guarding (integer division, rounds the reduction down).
const GUARD_REDUCTION_PCT: int = 50
## Percent of the cancelled hit sent back to the attacker.
const PARRY_REFLECT_PCT: int = 100
## Max Manhattan distance for a parry to reflect.
const PARRY_REFLECT_RANGE: int = 1

# ---------- Range ----------
## Base attack range (Manhattan) for Strike and Week 1 enemy attacks.
const STRIKE_RANGE: int = 1
## Extra range when the attacker's tile is higher than the target's.
const HIGH_GROUND_RANGE_BONUS: int = 1
