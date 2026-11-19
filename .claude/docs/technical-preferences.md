# Technical Preferences

<!-- project.yaml at the repo root is the machine-readable source of truth for
     engine, specialists, naming, performance, platform, and testing.framework.
     This file is the human-readable LEGACY FALLBACK: agents and skills resolve
     each key from project.yaml first and fall back here only when the
     project.yaml key is absent. /setup-engine dual-writes both.
     Forbidden patterns and allowed libraries are NOT migrated — they live only
     in this file. Populated by /setup-engine; updated as decisions are made. -->

## Engine & Language

- **Engine**: Godot 4.7.2
- **Language**: GDScript (typed)
- **Rendering**: Mobile renderer, 2D
- **Physics**: Godot Physics 2D (barely used; grid-based turns)

## Input & Platform

<!-- Written by /setup-engine. Read by /ux-design, /ux-review, /test-setup, /team-ui, and /dev-story -->
<!-- to scope interaction specs, test helpers, and implementation to the correct input methods. -->

- **Target Platforms**: Android (Google Play). iOS and Steam out of scope for now
- **Input Methods**: Touch (mouse for desktop testing)
- **Primary Input**: Touch, one thumb, portrait
- **Gamepad Support**: None
- **Touch Support**: Full
- **Platform Notes**: Portrait; touch targets >= 48 dp; key actions in the bottom 60%; handle safe areas/notches; app can be killed anytime (save every turn)

## Naming Conventions

- **Classes**: PascalCase
- **Variables**: snake_case
- **Signals/Events**: snake_case, past tense (`turn_ended`)
- **Files**: snake_case
- **Scenes/Prefabs**: snake_case
- **Constants**: SCREAMING_SNAKE_CASE

## Performance Budgets

- **Target Framerate**: 60 fps on a 2020 budget Android (Mali-G52)
- **Frame Budget**: 16.6 ms
- **Draw Calls**: < 150 per frame in battle
- **Memory Ceiling**: 400 MB

## Testing

- **Framework**: gdUnit4 6.2.3 (`addons/gdUnit4/`)
- **Minimum Coverage**: every sim rule has a test; sim determinism test must pass
- **Required Tests**: Balance formulas, gameplay systems, networking (if applicable)

## Forbidden Patterns

<!-- Add patterns that should never appear in this project's codebase -->
- `randi()`, `randf()`, `randomize()` or `RandomNumberGenerator` outside `src/sim/core/rng.gd`
- Any `Node`, scene, `Time`/`OS` call or delta inside `src/sim/`
- View code writing sim state
- Energy systems, gacha, premium currency, paid power, paid speed-ups, forced ads

## Allowed Libraries / Addons

<!-- Add approved third-party dependencies here -->
- gdUnit4 (tests)

## Architecture Decisions Log

<!-- Quick reference linking to full ADRs in docs/architecture/ -->
- [No ADRs yet — use /architecture-decision to create one]

## Engine Specialists

<!-- Written by /setup-engine when engine is configured. -->
<!-- Read by /code-review, /architecture-decision, /architecture-review, and team skills -->
<!-- to know which specialist to spawn for engine-specific validation. -->

- **Primary**: godot-specialist
- **Language/Code Specialist**: godot-gdscript-specialist
- **Shader Specialist**: godot-shader-specialist
- **UI Specialist**: godot-specialist
- **Additional Specialists**: godot-gdextension-specialist
- **Routing Notes**: `.gd` → gdscript specialist; `.gdshader` → shader specialist; `.tscn`/UI → godot-specialist

### File Extension Routing

<!-- Skills use this table to select the right specialist per file type. -->
<!-- If a row says [TO BE CONFIGURED], fall back to Primary for that file type. -->

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| Game code (primary language) | godot-gdscript-specialist |
| Shader / material files | godot-shader-specialist |
| UI / screen files | godot-specialist |
| Scene / prefab / level files | godot-specialist |
| Native extension / plugin files | godot-gdextension-specialist |
| General architecture review | Primary |
