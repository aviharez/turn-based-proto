class_name BattleViewConfig
extends RefCounted
## View-only layout, zoom and colour constants for the battle screen.
## Rules and balance never live here: those are in src/sim/tuning.gd and src/content/.

## World pixels per tile (art grid).
const TILE_PX: int = 32
## Tiles visible across the screen width at each zoom step: battle, mid, wide.
const ZOOM_TILES_ACROSS: Array[int] = [9, 11, 14]
const DEFAULT_ZOOM_STEP: int = 0
## Screen fraction (from the top) where the arena's top edge sits at every zoom step.
const ARENA_TOP_SCREEN_FRACTION: float = 0.085
## Thumb controls live below this screen fraction (the bottom 60%).
const THUMB_ZONE_TOP_FRACTION: float = 0.4
## Height of a terrace's front wall in world pixels (shows elevation in 3/4 view).
const TERRACE_WALL_PX: int = 8
## Tiles of dark jungle drawn around the arena so wider zoom steps have something to show.
const BACKDROP_TILES: int = 24
## Grey-box unit token radius in world pixels.
const TOKEN_RADIUS_PX: float = 11.0
## World-pixel font size for token letters.
const TOKEN_FONT_PX: int = 10

# Colours from assets/style/runedeep32.hex (index in brackets).
const C_OUTLINE: Color = Color("#0c0907")        # [1]
const C_BACKDROP: Color = Color("#243019")       # [7]
const C_FRAME: Color = Color("#364420")          # [8]
const C_GROUND_A: Color = Color("#5b5551")       # [4]
const C_GROUND_B: Color = Color("#555049")       # [4] darkened for the checker
const C_GRID_LINE: Color = Color("#373735")      # [3]
const C_TERRACE_TOP: Color = Color("#7e7969")    # [5]
const C_TERRACE_WALL: Color = Color("#373735")   # [3]
const C_BLOCKED: Color = Color("#2a251f")        # [12]
const C_BLOCKED_TOP: Color = Color("#544131")    # [13]
const C_SHADOW: Color = Color(0.0, 0.0, 0.0, 0.35)
const C_HERO: Color = Color("#455c7e")           # [28]
const C_TUYUL: Color = Color("#533f57")          # [29]
const C_BRUTE: Color = Color("#7f683b")          # [14]
const C_RIM: Color = Color("#d8dcdd")            # [31]
const C_HP_BACK: Color = Color("#33191f")        # [19]
const C_HP_FILL: Color = Color("#a93624")        # [23]
const C_HP_HERO: Color = Color("#81d593")        # [30]
const C_MOVE_FILL: Color = Color(0.271, 0.361, 0.494, 0.8)    # [28] at 80%
const C_MOVE_EDGE: Color = Color(0.847, 0.863, 0.867, 0.45)  # [31] at 45%
const C_STRIKE_EDGE: Color = Color("#da915d")    # [16]
const C_DANGER: Color = Color("#a93624")         # [23]
const C_INTENT_SELECTED_FILL: Color = Color(0.663, 0.212, 0.141, 0.55)  # [23] at 55%
const C_SELECT: Color = Color("#e6d082")         # [26]

## Inset of a highlighted tile from its edges, in world pixels.
const HIGHLIGHT_INSET_PX: float = 1.0


## Camera zoom factor that shows ZOOM_TILES_ACROSS[step] tiles across the viewport width.
static func zoom_for_step(viewport_width: float, step: int) -> float:
	var clamped: int = clampi(step, 0, ZOOM_TILES_ACROSS.size() - 1)
	return viewport_width / float(ZOOM_TILES_ACROSS[clamped] * TILE_PX)


## Camera centre (world px, snapped to whole pixels) that centres the arena horizontally
## and puts its top edge at ARENA_TOP_SCREEN_FRACTION of the screen height.
static func camera_position(viewport_size: Vector2, zoom: float, arena_size_px: Vector2) -> Vector2:
	var x: float = arena_size_px.x * 0.5
	var y: float = viewport_size.y * (0.5 - ARENA_TOP_SCREEN_FRACTION) / zoom
	return Vector2(roundf(x), roundf(y))


## Centre of a tile in world pixels.
static func cell_center(cell: Vector2i) -> Vector2:
	return Vector2(cell.x * TILE_PX + TILE_PX * 0.5, cell.y * TILE_PX + TILE_PX * 0.5)


## Tile under a world-pixel position (may be outside the arena).
static func world_to_cell(world: Vector2) -> Vector2i:
	return Vector2i(floori(world.x / TILE_PX), floori(world.y / TILE_PX))
