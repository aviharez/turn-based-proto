# Current milestone: M0 — Project setup → M1 Battle slice

## M0 (done when merged)
- [x] CCGS template, AGENTS.md / CLAUDE.md rules, project skills
- [x] Godot 4.7.2 project, portrait Android settings, sim/view folders
- [x] Seeded Rng + SimEvent + grid basics with gdUnit4 tests, `make check`
- [ ] Owner: run `/start` in Claude Code once to confirm rigor/automation modes
- [ ] Owner: pick the Godot MCP (godot-mcp-runtime or hi-godot/godot-ai)

## M1 — Battle slice (build order step 1 in design/game-brief.md)
- One 7×8 arena, silat hero vs 3 tuyul + 1 brute
- Intents, Guard, Parry, Focus; lose when hero HP = 0
- Acceptance: a full battle plays on an Android phone at 60 fps, each turn resolves in < 1.5 s of animation
