# W1-28 Feel pass v1
> Lane: @claude · Type: Visual · Size: M · Depends on: W1-26 · Spec: pixel-techniques hit-feedback.md, damage-flash.md

**Goal:** turns feel snappy: the brief's kill condition is "slow or confusing".

## Acceptance criteria
- [ ] Move tween ≤ 0.15 s per tile. The whole enemy phase plays in ≤ 2.5 s with 4 enemies. A tap during enemy animations speeds them up ×3.
- [ ] Hit: white flash (2 frames) + 1–2 px knockback + damage number. Parry: a short hit-stop (≤ 80 ms), a gold flash and the reflected number flying back to the attacker.
- [ ] Every timing value lives in a view config. The quality bar (`.claude/skills/quality-bar/SKILL.md`, VFX checklist) is run, with evidence attached.

## Evidence
Before/after GIF in `production/devlog/media/`, plus the quality-bar checklist in the PR.
