# Game Brief: Runedeep (working title)

## In your words
"i want to develop a pixel game … a fun to play game, with some difficulties that makes player want to play the game more; not a pay to win game; can give me an income; prior to mobile game."
"steam game Dimraeth (love the complexity) … it also have something like building house."
"actually i think a complex game like dimraeth is rare on mobile. if turn-based market is good, i can go with turn-based gameplay."
"about theme … nusantara inspired theme … for the dialogue, i think just use AI"
"we need to limit the cuteness to make male player also enjoy it."
"make sure that the UI design, the game design, the vfx is really good. those are some of the selling point of a game."
"this is not a retro pixel okay. we need to target a modern pixel game. the screen also needs to be able to show a good information. not too narrow, especially we will create a building feature."
"the tiles feels like a wallpaper. it doesnt have dimension."

**Pitch:** Weave runes into your own spells, read the spirits' intents and parry them back, then bring the loot home to build and decorate a village in a Nusantara-inspired archipelago.

**Genre:** Turn-based tactical RPG with roguelike expeditions and a settlement builder (Dimraeth-like depth, on mobile).

**Controls:** Portrait, one thumb. Tap a unit/tile to select, tap a highlighted tile to move or target, action bar in the bottom 60% (Strike, Cast, Guard, Parry, End turn). Build mode: drag a ghost footprint, it snaps to the grid, tap Confirm. Three fixed zoom steps via buttons; no pinch in battle.

**Question:** Is a 10–20 minute turn-based expedition with spell weaving and Guard/Parry tense and snappy enough on a phone that players want "one more floor"?

**Hooks:** Spell weaving (Element + Shape + up to 2 Modifiers, 5 grimoire slots); telegraphed enemy intents with Guard and Parry for an action feel in turns; bank-or-push-on risk at shrines; a settlement and house you build from what you bring back.

**Intent:** payoff builds (you said: Dimraeth complexity) · staged failure (provisional: death loses only unbanked loot)

## Look and references
- Look: modern pixel art, not retro. 32 px tiles, heroes ~3 heads tall (no chibi), spirits eerie-but-charming with a 1 px pale rim. Earthy Nusantara palette: moss greens, laterite reds, volcanic stone, warm gold light. Every scene has depth: ground, raised terraces with side walls, tall Y-sorted props with shadows, a foreground canopy frame, light shafts and colour grading. UI at native resolution, crisp and readable.
- References: Dimraeth (systems depth, home base, house), Into the Breach (telegraphed intents, small readable boards), Slay the Spire (one-more-run pacing), SpriteCook concept B (`30acd643-…`) as the depth target.
- View: 2D · Camera: 3/4 top-down, Camera2D at 3 fixed zoom steps (battle 9 tiles across, build ~14), sharp-bilinear upscaling.

## First minute
The hero (a silat fighter) wakes in a ruined candi clearing in Wanaraga. A tuyul snatches an offering and its intent arrow shows it will flee next turn; the player taps to move and Strike. A second spirit shows a red attack intent on the hero's tile; a pulsing Guard button teaches blocking, then the next hit teaches Parry and the damage bounces back with a big flash. The player picks up a Fire rune and a Bolt shape and casts their first woven spell at a clump of enemies. A shrine appears: "Bank your loot or go deeper?"

## Challenge
Floor 2 (minute 3–5) adds enemies whose intents combine, so the player must choose which hit to Guard and which to dodge. Losing costs the unbanked loot of that expedition only; hero level, gear and the settlement are kept. Later floors add hazards (water, vines, cursed tiles) and elevation (high ground +1 range), and each region ends with a boss with multi-tile intents (Buto Ijo, Harimau Kumbang, Naga Samudra).

## Core loop
- Prepare at home (2–5 min): cook a meal (buff), craft or upgrade gear, pick 5 spells and 1 ally.
- Expedition (10–20 min, pause any time): clear 3–5 grid floors with enemies, hazards, chests and sometimes an ally to rescue.
- Bank or push on at each shrine; dying loses unbanked loot.
- Return: spend materials on buildings, house decor, ally facilities and gear; level up; advance quests and friendships.

## Goal & fail state
- Goal: clear each region's story chapter and boss; grow the settlement and allies; master deeper Endless Depths runs.
- Fail: the hero's HP reaches 0 on an expedition → the run ends, unbanked loot is lost, the player returns home.

## Features
- [ ] Turn-based battle on a grid (walkable ~7×8 inside the 9-wide view) with move, Strike, Cast, Guard, Parry, Focus and telegraphed intents
- [ ] Spell weaving: Element + Shape + up to 2 Modifiers, 5 grimoire slots, attribute gates (Might / Wits / Spirit)
- [ ] Expedition run: 3–5 floors, shrines with bank-or-push-on, seeded generation
- [ ] Persistent hero: level, gear (5 rarities), skill tree for 1 of 12 archetypes (3 origins × 4 callings)
- [ ] Settlement grid: ~12 buildings, farms/quarries producing offline (24 h cap)
- [ ] House interior you decorate with found/crafted/cosmetic furniture
- [ ] Allies (~8) who move in, run facilities and join as 1 companion

## Your systems
- turn-based battle with intents, Guard and Parry · in the slice
- spell weaving · in the slice
- expedition floors and shrines · in the slice
- settlement building · thin stand-in
- house decorating · thin stand-in
- crafting: forge, alchemy, kitchen · thin stand-in
- allies, facilities and friendships · later
- 12 archetypes and skill trees · later
- modes: Oaths, Endless Depths, Daily Expedition · later
- AI-written dialogue · thin stand-in

## Keep
-

## Avoid
- Pay-to-win of any kind: energy, gacha/loot boxes, premium currency, paid power, paid speed-ups, forced ads
- Too much cuteness (chibi, big shiny eyes, plush spirits)
- Retro low-res look and a narrow cramped screen
- Flat "wallpaper" floors without depth
- Sacred or religious figures as enemies (Nyi Roro Kidul, Dewi Sri, Semar/Punakawan, Barong/Rangda); pocong and wewe gombel

## Out of scope
- iOS and Steam releases (for now)
- Multiplayer and co-op (later: visiting friends' settlements, trading, leaderboards)
- Real-time combat
- Voice-acted dialogue

## Build order
1. Battle slice: one 7×8 arena, silat hero vs 3 tuyul + 1 brute, intents, Guard/Parry, Focus. Lose = hero HP 0. Prove it feels snappy.
2. Spell weaving with 4 elements, 3 shapes, 2 modifiers; grimoire of 5.
3. Expedition of 3 floors with a shrine and bank-or-push-on; seeded floors.
4. Home stand-in: settlement grid with 3 buildings and build-mode zoom; meals as buffs.
5. First boss (Buto Ijo, 2×2) and the Wanaraga chapter opening.
6. House decorating stand-in and the first ally.

---
**Kill condition:** if a battle turn still feels slow or confusing on a phone after two tuning rounds of the battle slice.

**Who it's for / what they feel:** mobile players (male and female, 18–40) who want Dimraeth-like depth in 10–20 minute sittings and feel clever when a parry or a woven spell turns a fight.

**Games you love / don't:** Love Dimraeth (complexity, house building). Don't love energy/gacha mobile RPGs.

**Monetization (hard rule):** free download with a $5.99 full-game unlock; cosmetics (decor packs, hero skins) and a supporter pack. Nothing that affects power or time.
