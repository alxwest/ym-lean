#!/usr/bin/env bash
# Submit the sibling ym-ymg checkout to ym-lean's existence-only verifier.
# This does not translate JointExistence into YangMillsExistenceOnly.
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
proof="${YM_YMG_ROOT:-$root/../ym-ymg}/submissions/openai-20261028/submission/Solution.lean"

cd "$root"
exec python3 scripts/verify_submission.py \
  --claim existence \
  --proof-file "$proof" \
  --theorem YangMills.jointExistence \
  --report .lake/ym-ymg-existence-report.json
