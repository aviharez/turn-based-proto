#!/usr/bin/env bash
# Fails if src/sim/ uses forbidden APIs (nodes, time, global randomness).
set -euo pipefail
cd "$(dirname "$0")/../.."
fail=0
check() { # pattern, message, [exclude-file]
  local hits
  hits=$(grep -rnE "$1" src/sim --include='*.gd' | grep -v "${3:-__none__}" || true)
  if [ -n "$hits" ]; then echo "SIM PURITY: $2"; echo "$hits"; fail=1; fi
}
check '(^|[^.[:alnum:]_])rand(i|f|i_range|f_range|omize|_from_seed)\s*\(' "use Rng, not global randomness" 'src/sim/core/rng.gd'
check 'RandomNumberGenerator' "only src/sim/core/rng.gd may use RandomNumberGenerator" 'src/sim/core/rng.gd'
check 'extends +(Node|Node2D|Control|CanvasItem|Sprite2D)' "sim classes must extend RefCounted/Resource, not nodes"
check '\b(Time|OS)\.|get_tree\(|_process\(|_physics_process\(' "no time, OS, scene tree or frame callbacks in sim"
[ $fail -eq 0 ] && echo "sim purity: OK"
exit $fail
