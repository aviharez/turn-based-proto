# W1-27 Unit names and codex text
> Lane: @claude (writer) · Type: Config/Data · Size: S · Depends on: W1-12 · Spec: AGENTS.md writing rules; design/lore/*

**Goal:** final names and one codex entry per Week 1 unit, in en and id.

## Acceptance criteria
- [ ] The brute gets a final name that fits `design/lore/sensitivity.md` ("genderuwo-like", not a sacred figure), and the owner confirms it in the PR.
- [ ] Name keys `UNIT_SILAT`, `UNIT_TUYUL`, `UNIT_BRUTE` (pattern `UNIT_<ID>`, uppercase content id) are in `src/content/text/`, en and id. The HUD intent line already uses them.
- [ ] Each codex entry is at most 2 sentences, avoids `banned-phrases.md` and is concrete, following the style guide.
- [ ] `/text-review` is run and its result is in the PR.
