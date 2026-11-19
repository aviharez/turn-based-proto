# Content data

Data-driven game content. One JSON file per content type (`runes.json`, `enemies.json`,
`relics.json`, ...), loaded by the sim through a loader that validates every entry.
Player-facing text lives in `text/*.csv` with `keys,en,id` columns (Godot imports these
as translations). New content needs a codex entry and both language columns.
