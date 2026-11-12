#!/usr/bin/env bash
# Submit the sibling ym-ymg checkout to ym-lean's existence-only verifier.
# The source translation is checked first. It is not yet a bridge to
# YangMillsExistenceOnly: the native verifier still checks that exact target.
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
submission="${YM_YMG_ROOT:-$root/../ym-ymg}/submissions/openai-20261028/submission"
"$root/scripts/translate_ym_ymg.sh"
submission="$(cd -- "$submission" && pwd)"

# The projects both use `YangMills` for incompatible public definitions.
# Recheck namespace-renamed wrappers; never rewrite the original submission.
# Lake builds the internal YM imports upstream and reuses completed modules.
stage="$root/.lake/ym-ymg-integration"

# `lake env` in the verifier preserves this additional import directory.
export LEAN_PATH="$stage/.lake/build/lib/lean:$submission/.lake/build/lib/lean${LEAN_PATH:+:$LEAN_PATH}"

cd "$root"
exec python3 scripts/verify_submission.py \
  --claim existence \
  --proof-file "$stage/YMGBridge/Solution.lean" \
  --theorem YMGBridge.jointExistence \
  --report .lake/ym-ymg-existence-report.json
