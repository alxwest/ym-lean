# Source-native YM-ymg non-vacuum check (Lean 4.32.0)

These two files are an **independently compiled, supplementary source-side
proof**, targeting the exact `PublicTheory` and `ChallengeSpec` definitions
of [alxwest/YM-ymg](https://github.com/alxwest/YM-ymg/tree/55ba9fc36293b3f4d52c6b1f813169a0be76ee98).
They live here in the `ym-lean` repository to make the checked work reviewable
without modifying the October submission's immutable original distribution.
They are not part of `ym-lean`'s Lean 4.31.0 library or its mass-gap claim.

`ExcitationFromPublic.lean` proves:

- `YangMills.WightmanTheory.hasFieldExcitation_of_centered_nonzero`
- `YangMills.Hierarchy.nonvacuum_of_reconstructed_nonzero_trace`

The second theorem assumes the selected `centeredTrace ≠ 0` as an explicit
hypothesis. Its connection to the construction's `TraceExtension.nonzero_strength`
is not yet assembled as a checked theorem. No mass gap is assumed.

## Reproduce using the source checkout

Copy the two files into the fork's
`submissions/openai-20261028/checks/` directory, **not** its preserved
`submission/` directory. From the latter directory run:

```sh
lake exe cache get
lake build ChallengeSpec
lake env lean -R ../checks -DautoImplicit=false -DwarningAsError=true \
  -o .lake/build/lib/lean/ExcitationFromPublic.olean \
  ../checks/ExcitationFromPublic.lean
lake env lean -R ../checks -DautoImplicit=false -DwarningAsError=true \
  ../checks/ExcitationFromPublicAudit.lean
```

Both checks passed on `ym-runner-2` on 11 November 2026 under the source's
pinned Lean 4.32.0/Mathlib dependencies; axiom dependencies were exactly
`propext`, `Classical.choice`, and `Quot.sound`.

These checks are **not** part of the original A1–A8 acceptance/Comparator
endpoints or a proof of the full `YangMillsExistenceOnly` statement.
