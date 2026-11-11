# YM-ymg → ym-lean: existence-only Wightman bridge (11 November 2026)

## Scope and pinned inputs

This is a **partial, gap-free** formal comparison. It is not a proof of either
`YangMillsExistenceOnly` or the Jaffe–Witten existence-and-mass-gap problem.

- [Construction fork `alxwest/YM-ymg`](https://github.com/alxwest/YM-ymg/tree/55ba9fc36293b3f4d52c6b1f813169a0be76ee98), commit `55ba9fc36293b3f4d52c6b1f813169a0be76ee98`, Lean 4.32.0.
- [Specification `alxwest/ym-lean`](https://github.com/alxwest/ym-lean/tree/3bc0411516ae9fb01e6992106f4bac122b5af897), baseline commit `3bc0411516ae9fb01e6992106f4bac122b5af897`, Lean 4.31.0.
- **Target:** [`YangMillsExistenceOnly`](../YangMills/ExistenceOnly.lean), which has no spectral mass-gap condition. The independent full problem statement is unchanged.

The two projects cannot currently be imported into one ordinary Lake build
without resolving their toolchain, Mathlib and duplicate namespace/definition
interfaces. The following proofs check the *target-side mathematics* of
one bridge step, not the source-to-target transport.

## Verified step: a non-vacuum excitation without a mass gap

[Lean proof](../YangMills/YMYMGExistenceBridge.lean):

- `WightmanData.hasFieldExcitation_of_centered_twoPoint`:
  a nonzero actual Minkowski two-point vacuum word with a centered left field
  forces an actual field word outside the vacuum line.
- `WightmanData.hasFieldExcitation_of_centered_faithful`:
  **stronger for YM-ymg**: in a cyclic normalized Wightman theory, if one
  centered field has a nonzero smeared operator, the physical field algebra
  creates a state outside the vacuum line. A bare nonzero uncentered field
  (notably the identity) is insufficient.
- `CenteredTraceKinematicInput.toExistenceKinematics` constructs the
  `QuantumTheory`, `WightmanAxioms`, `HasFieldExcitation`, and
  `WightmanVacuumKernels` portion from *one and the same* physical theory.
- `FilteredExistenceCandidate.toExistenceKinematics` projects an actual
  existence-only candidate onto precisely this checked portion. No
  gauge-dependent generated sector is manufactured.

**Neither proof adds or assumes a mass gap, an unrelated Hilbert space or
an alternative vacuum.** The source-facing input is conditional: its
Wightman and kernel fields still need exact transport from YM-ymg.

## Why the faithful-centered route applies to the source's advertised data

These are **source-side ingredients**, not yet a checked cross-project theorem.
A standalone **source-native** Lean 4.32 proof has been separately compiled:
[ExcitationFromPublic.lean](YM_YMG_SOURCE_CHECKS/ExcitationFromPublic.lean)
uses `WightmanTheory.Axioms` and `Hierarchy.Reconstructed` with an explicit
nonzero centered-trace-field hypothesis to derive a non-vacuum physical field
word. See the [source-side reproduction guide](YM_YMG_SOURCE_CHECKS/README.md).
The direct final instantiation of the construction's own trace-nonzero
witness into that second theorem remains to be formalized.

The relevant advertised source results are:

1. [`PublicView.view_axioms`](https://github.com/alxwest/YM-ymg/blob/55ba9fc36293b3f4d52c6b1f813169a0be76ee98/submissions/openai-20261028/submission/PublicView.lean) proves the source's W0–W3 axioms for its reconstructed physical fields, including cyclicity and a normalized vacuum.
2. [`ChallengeSpec.Hierarchy.Reconstructed`](https://github.com/alxwest/YM-ymg/blob/55ba9fc36293b3f4d52c6b1f813169a0be76ee98/submissions/openai-20261028/submission/ChallengeSpec.lean) includes field faithfulness; [`HierarchyBridge.publicReconstruction`](https://github.com/alxwest/YM-ymg/blob/55ba9fc36293b3f4d52c6b1f813169a0be76ee98/submissions/openai-20261028/submission/HierarchyBridge.lean) instantiates it on the selected reconstructed theory.
3. The centered stress trace is the **same** `TraceExtension.center F` field used in the construction. The [`TraceTest.centered` and `shortDistance` clauses](https://github.com/alxwest/YM-ymg/blob/55ba9fc36293b3f4d52c6b1f813169a0be76ee98/submissions/openai-20261028/submission/ChallengeSpec.lean) are retained by the construction; [`NonzeroPhysicalObservable.probe_from_trace`](https://github.com/alxwest/YM-ymg/blob/55ba9fc36293b3f4d52c6b1f813169a0be76ee98/submissions/openai-20261028/checks/NonzeroPhysicalObservable.lean) derives `center F ≠ 0` from the source's leading trace estimates.
4. Faithfulness combined with the nonzero **label** would give some nonzero smeared trace operator; centeredness and cyclicity then give the `HasFieldExcitation` result above. This avoids requiring an unproved *Euclidean nonzero correlator → Minkowski nonzero two-point word* implication.

## Verified source/target spacetime coordinate convention

[`YMYMGSpacetimeBridge.lean`](../YangMills/YMYMGSpacetimeBridge.lean) supplies
an explicit invertible reindexing of `EuclideanSpace ℝ (Fin 4)` (source
physical time at coordinate 3) onto `Fin 4 → ℝ` (target physical time at
coordinate 0). It verifies the **same bilinear Minkowski form**, the
source's norm-based **forward cone** and **spacelike-separation criterion**.
This is a theorem over the exact common Mathlib mathematical types; it does
additionally gives an **all-arity continuous linear equivalence** of the
source `SchwartzMap (Points n) ℂ` and the target's full joint Schwartz
space. It proves inverse transport of continuous n-point functionals and
preservation of tensor-product test evaluations. Thus the joint Schwartz
**test-space** and its linear functional type are no longer obstacles.
It does not import the source's full Wightman representation or identify
those functionals with the target's actual field words or spectral measure.

## Exact source-facing obstacles still open

| Required transport | What exists in YM-ymg | What is not yet formalized across the repositories |
| --- | --- | --- |
| Group-specific QFT | Matrix `GaugeGroup` and selected `view F.action` | Transport an arbitrary connected compact simple `G` and its group action; [issue #1](https://github.com/alxwest/ym-lean/issues/1) |
| `WightmanData` fields/axioms | `PublicTheory.W0`–`W3` and `PublicView.view_axioms` | Coordinate permutation/causal cones DONE; finite-component label decomposition, separability, target domain and covariance proofs remain |
| Actual Hamiltonian | Strongly continuous Poincaré translations with a joint energy–momentum projection-valued measure | Construct the self-adjoint infinitesimal **time generator** and prove exact full-domain/action and resolvent-spectrum conditions. No positive gap is demanded |
| Joint Schwartz vacuum kernels | Source's selected phase boundary distributions and `PublicView.publicMoment` | Full Schwartz space and continuous functional transport DONE for every arity; still must identify the *particular* source kernels with the **same** physical smeared field words, establish product tensor-map/density, and transport source phase identities; [issue #4](https://github.com/alxwest/ym-lean/issues/4) |
| Centered trace | `TraceTest.centered`, nonzero `center F`, and field faithfulness | Map the exact selected trace label/operator to the target `WightmanData.FieldIndex` and import its centering/faithfulness |
| Generated Yang–Mills identification | Wilson origin, stress and OPE assertions | Satisfy the fixed Ward/CS, all-order perturbative, renormalized composite and stress obligations of `FilteredRG.GeneratedSector`; [issues #2](https://github.com/alxwest/ym-lean/issues/2), [#6](https://github.com/alxwest/ym-lean/issues/6), [#8](https://github.com/alxwest/ym-lean/issues/8) |

These are **missing implication proofs**, not assertions of mistakes in the
source's Lean theorems. The October submission itself explicitly omits
all-orders perturbative matching, and this comparison preserves that scope.

## Reproduce the local checks

From the `ym-lean` checkout, with its pinned Lean 4.31.0 and Mathlib cache:

```sh
lake build YangMills.ExistenceOnly
lake build YangMills.YMYMGExistenceBridgeAudit YangMills.YMYMGSpacetimeBridgeAudit YangMills
```

The two audit files print transitive axiom dependencies of all checked
theorems. All reported only `propext`, `Classical.choice`, and
`Quot.sound` on `ym-runner-2`, 11 November 2026.

**Next proof:** a concrete source-side `CenteredTraceKinematicInput`
adapter with the exact `YM-ymg` Wightman structure, Hamiltonian, and joint
Schwartz kernels. Until then, neither `ExistenceKinematics` nor
`YangMillsExistenceOnly` has been instantiated by this source in Lean.
