#!/usr/bin/env bash
# Check the universe-independent translation of the October SOURCE theorem.
# Success does not certify YangMillsExistenceOnly.
set -euo pipefail

if (( $# )); then
  echo "Usage: translate_ym_ymg.sh (set YM_YMG_ROOT for another checkout)" >&2
  exit 1
fi

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
submission="${YM_YMG_ROOT:-$root/../ym-ymg}/submissions/openai-20261028/submission"
packages="$(python3 "$root/scripts/prepare_ym_ymg.py" "$submission")"
stage="$root/.lake/ym-ymg-integration"

log="$root/.lake/ym-ymg-translation-build.log"
if ! lake -d "$stage" --packages="$packages" build +YMGBridge.Solution >"$log" 2>&1; then
  tail -80 "$log" >&2
  echo "Translation build failed; full log: $log" >&2
  exit 1
fi
echo "Translation build log: $log"
lake -d "$stage" --packages="$packages" env lean --run \
  "$root/scripts/InspectYMGTranslation.lean" YMGBridge.Solution YMGBridge.jointExistence
