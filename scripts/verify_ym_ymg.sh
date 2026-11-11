#!/usr/bin/env bash
# Submit the sibling ym-ymg checkout to ym-lean's existence-only verifier.
# This does not translate JointExistence into YangMillsExistenceOnly.
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
submission="${YM_YMG_ROOT:-$root/../ym-ymg}/submissions/openai-20261028/submission"
packages="$(python3 "$root/scripts/prepare_ym_ymg.py" "$submission")"
submission="$(cd -- "$submission" && pwd)"

# The projects both use `YangMills` for incompatible public definitions.
# Recheck namespace-renamed wrappers; never rewrite the original submission.
# Lake builds the internal YM imports upstream and reuses completed modules.
stage="$root/.lake/ym-ymg-integration"
lake -d "$stage" --packages="$packages" build +YMGSubmission.Construction

# `lake env` in the verifier preserves this additional import directory.
export LEAN_PATH="$stage/.lake/build/lib/lean:$submission/.lake/build/lib/lean${LEAN_PATH:+:$LEAN_PATH}"

cd "$root"
exec python3 scripts/verify_submission.py \
  --claim existence \
  --proof-file "$stage/YMGSubmission/Solution.lean" \
  --theorem YMGSubmission.jointExistence \
  --report .lake/ym-ymg-existence-report.json
