# Runedeep — common commands. Override the Godot binary with: make check GODOT=/path/to/godot
GODOT ?= godot

.PHONY: import test purity smoke check run art-check

import:            ## Build the .godot cache (needed once on a fresh clone and after adding classes)
	$(GODOT) --headless --path . --import

test: import       ## gdUnit4 tests (exit 0 = pass)
	$(GODOT) --headless --path . -s -d --remote-debug tcp://127.0.0.1:0 res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://tests --ignoreHeadlessMode -c

purity:            ## Static check: src/sim stays deterministic and node-free
	./tools/ci/check_sim_purity.sh

smoke: import      ## Boot the main scene headless for a few frames and fail on script errors
	@out=$$(timeout 60 $(GODOT) --headless --path . --quit-after 30 2>&1); echo "$$out" | tail -5; \
	if echo "$$out" | grep -qE "SCRIPT ERROR|Parse Error"; then echo "smoke: FAILED"; exit 1; else echo "smoke: OK"; fi

check: purity test smoke  ## Definition of done for every task
	@echo "make check: ALL PASSED"

run:
	$(GODOT) --path . --windowed --resolution 540x1200

art-check:         ## Placeholder until the palette/size checker lands (ai-art-pipeline skill)
	@echo "art-check: not implemented yet (tracked in production/milestone.md)"
