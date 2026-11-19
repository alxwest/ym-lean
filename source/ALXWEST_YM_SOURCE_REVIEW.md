# alxwest/ym against the ym-lean specification

The reviewed source is `alxwest/ym` at `a23b9a07863c7ad03516927390a60b5ef4ab9b3a`.
This review covers its selected H176 heat/Hodge route, the sampled Wilson
comparisons and the Qcos tests that target the Lean witness. The selected
H176 tower refines by denominator doubling. The source describes a research
programme with a finite construction and open physical stages. Its Lean
project checks C0/C1 structural lemmas and its Qcos packet
includes two further Lean consequences of the corrected native candidate.
[Source revision][source] · [H176 tower][c0] · [C0–C6 status][status] ·
[Lean scope][finite-lean]

The native existence-only and full targets both quantify over actual compact
connected Lie groups with simple Lie algebra. For each group they require
the same physical theory for the joint Wightman fields, full vacuum kernels,
the composite correspondence, generated ultraviolet and OPE matching, and
the stress charges and centered trace. The existence-only witness calls
for a non-vacuum field word. The full witness requires a positive finite
mass on its own Hamiltonian. The specification allows the constructor
to choose the regulator. [Native existence][existence] · [Full target][full] ·
[Shared generated sector][sector]

## Open issues

| Requirement | What the source supplies and what the native witness still needs | Issue |
| --- | --- | --- |
| Physical transfer and continuum generator | In the original C1 static route, the fresh adjacent law defects are nonsummable at `Λ_N = 102 + N` even though the fixed-coarse marginals converge to Haar. The static norm-resolvent limit is the bare kinetic operator at each fixed coarse level. On diagonals approximating those limits the excited resolvent vanishes, leaving only the vacuum term. The obstruction applies to the stated static completion and original maps. A physical transfer with an excitation-preserving recovery and the full time-translation derivative domain is still needed. [O0–O2][static] · [Native operator and domain][generator] | [#39][issue-transfer] |
| Joint continuum fields | C4 gives conditional criteria for a uniformly controlled joint source hierarchy and a common physical left/right cut. The sampled Wilson hierarchy controls positive truncated leaves in boxes that shrink in physical units along the stated logarithmic coupling. A faithful recovery of the entire tested moving Qcos Wilson family fails separability even for existence-only. The native target needs a separable Wightman theory with full vacuum kernels, a joint composite dictionary and an excitation. [C4 inputs][c4] · [Wilson hierarchy][positive-wilson] · [Moving probes][moving] · [Native kernels][kernels] | [#40][issue-continuum] |
| Physical coupling, ultraviolet matching and OPE | Route C-EDGE fixes the finite spatial profile and identifies missing electric/magnetic response drift and diagonal estimates. The periodic Wilson comparison reports a leading one-loop agreement of the two normalized response coefficients. Its one-shell marked score through `g²` uses the original raw prior and has independent review pending. The native target needs a physical coupling and all-orders coefficient and actual-word remainder bounds for the same continuum hierarchy, with the fixed generated Ward and Callan–Symanzik data. [Response conditions][c5] · [One-loop slopes][slopes] · [One-shell scope][score] · [Review ledger][score-ledger] · [Native matching][matching] | [#41][issue-uv] |
| Stress, charges and trace | The source gives conditional local metric and Ward passage theorems. The chosen continuum fields still need a tensor insertion on their common domain, global charges on a graph core for the same generators, and the exact centered trace with their running beta value and curvature square. [Metric variation][metric] · [Translation Ward identity][ward] · [Native stress and charges][stress] · [Centered trace][trace] | [#42][issue-stress] |
| Physical spectral mass | The fixed-`I` finite IR/UV admission bounds a parent-conditional source observable. Even summable retained and leakage resolvent errors with a hidden compression floor can coexist with a vanishing gap. The selected Qcos transfer has an abstract gap and positive-energy spectral measures carried by a Lebesgue-null set. The latter property excludes a nontrivial same-time reducing sector with the required boost covariance. A physical estimate on the recovered joint space and a positive point of its native spectrum remain open. [Finite admission][finite-atlas] · [C3 and counterexample][c3] · [Qcos boost obstruction][boost] · [Native gap transfer](../integrations/alxwest_ym/README.md) | [#43][issue-gap] |
| All-group construction | The selected heat law is formulated for compact simple groups. Its Lean lemmas work for abstract groups under explicit finite-law premises, while the source's numerical finite admissions use particular `SU(2)` data. The construction needs an instantiation for each native global group and a physical and identification proof for each resulting theory. Estimates may use group-dependent constants. [C1 law][c1] · [Finite Lean scope][finite-lean] · [Native group][group] | [#44][issue-groups] |

## Countermodel tests and the stress cutoff

The Qcos comparison gives a continuous-mass generalized-free candidate with
an explicit positive mass-squared measure. On its tested domain, a finite
regular local Wick stress gives a compact mass kernel for a spatial charge.
The nonzero momentum on the tested packet acts as a multiple of the
identity in that infinite-dimensional mass variable. The finite scalar and
massive Proca controls also fail the two prescribed stress-curl shapes in
the leading actual-word matching test. General composite
assignments on a generalized-free space remain a fidelity question.
[Continuous-mass proof][continuous] · [Finite two-shape proof][shapes] · [#5 update][issue-countermodel]

The same source documents an earlier Lean defect. The exclusive cutoff
`4` excluded the degree-four terms forced by the canonical stress tree.
Commit `3bc0411` changed the stress dictionary and its RG frame to the
exclusive cutoff `5`. The reviewed native revision includes that correction.
[Historical argument][old-cutoff] · [Repair][cutoff-fix] · [Current dictionary][sector]

## Mechanical checks

- The pinned upstream `formal/lean` project rebuilt on Lean 4.33.0 in an
  isolated directory. `lake env lean Audit.lean` checked all 34 finite lemmas.
  Their transitive axioms are drawn from `propext`, `Classical.choice` and
  `Quot.sound`. [Upstream audit][finite-audit]
- Both native verifier modes passed the compiled target-shape check and
  returned `PROOF_NOT_SUBMITTED`. No existence or full-gap declaration was
  available for the exact-target kernel check. [Admission contract](../CERTIFICATION.md)
- The two `corrected_running.lean` lemmas replayed against the reviewed native
  checkout with Lean 4.32.0. They prove the vanishing of the series below degree
  three and an eventual quadratic bound on the actual beta function, assuming
  a native candidate. Their transitive axioms are `propext`,
  `Classical.choice` and `Quot.sound`. [Lean replay input][running]
- The original curl and corrected two-shape Python controls reproduced the
  exact rational ratios and a nonzero two-shape determinant. The controls
  check the stated finite calculations. [Curl control][curl-script] · [Two-shape control][shape-script]
- The static-route checks at seeds 0 and 73 reproduced the committed JSON
  outputs byte for byte. They cover finite incidence, density comparisons
  and rational estimates used alongside the analytical obstruction.
  [Static-route replay inputs][static-check]

[source]: https://github.com/alxwest/ym/tree/a23b9a07863c7ad03516927390a60b5ef4ab9b3a
[c0]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/CLAY_CONSTRUCTION_ROUTE.md#L45-L65
[status]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/CLAY_CONSTRUCTION_ROUTE.md#L739-L751
[finite-lean]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/formal/lean/README.md#L13-L60
[finite-audit]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/formal/lean/Audit.lean
[existence]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/ExistenceOnly.lean
[full]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/YangMillsSpecification.lean
[sector]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/FilteredQuantumRG.lean#L235-L257
[static]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/c2_c1_static_route_obstruction_20261102/PROOF.md#L303-L461
[static-check]: https://github.com/alxwest/ym/tree/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/c2_c1_static_route_obstruction_20261102
[generator]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/QFT/Wightman.lean#L130-L145
[c4]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/CLAY_CONSTRUCTION_ROUTE.md#L462-L501
[positive-wilson]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/ym_wilson_positive_hierarchy_20261109/README.md#L1-L7
[moving]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/qcos_corrected_lean_wilson_composites_20261108/FULL.md#L26-L32
[kernels]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/WightmanVacuumKernels.lean#L21-L34
[c5]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/CLAY_CONSTRUCTION_ROUTE.md#L686-L737
[slopes]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/ym_wilson_sourced_hessian_slopes_20261109/README.md#L3-L8
[score]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/ym_wilson_hard_boundary_score_20261109/BULK_SCORE.md#L44-L52
[score-ledger]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/ledger/stream0_ym_wilson_hard_boundary_score_20261109.yaml
[matching]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/FilteredQuantumRG.lean#L76-L174
[metric]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/stream7/STRESS_TENSOR_METRIC_VARIATION_GATE.md#L7-L82
[ward]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/stream7/STRESS_TENSOR_WARD_IDENTITY_GATE.md#L47-L96
[stress]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/StressTensor.lean#L127-L166
[trace]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/CenteredTraceAnomaly.lean#L74-L92
[finite-atlas]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/stream0/S0_FINITE_IR16952_UV255000_ADMISSION_20261030.md#L7-L15
[c3]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/CLAY_CONSTRUCTION_ROUTE.md#L639-L684
[boost]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/qcos_gap_physical_spectral_support_20261108/PROOF.md#L35-L88
[c1]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/programme/ym_mass_gap_route/CLAY_CONSTRUCTION_ROUTE.md#L77-L125
[group]: https://github.com/alxwest/ym-lean/blob/1c7ffbd556a28c5331d08ca598f617a22a20733a/YangMills/GaugeGroup.lean#L20-L39
[continuous]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/qcos_wilson_lean_composite_20261108/CONTINUOUS.md#L3-L19
[shapes]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/qcos_corrected_lean_wilson_composites_20261108/SHAPES.md
[old-cutoff]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/qcos_wilson_lean_composite_20261108/LEAN_DEFECT.md
[cutoff-fix]: https://github.com/alxwest/ym-lean/commit/3bc0411516ae9fb01e6992106f4bac122b5af897
[running]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/qcos_corrected_lean_wilson_composites_20261108/corrected_running.lean
[curl-script]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/qcos_wilson_lean_composite_20261108/check_curl.py
[shape-script]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/qcos_corrected_lean_wilson_composites_20261108/check_stress_shapes.py
[issue-transfer]: https://github.com/alxwest/ym-lean/issues/39
[issue-continuum]: https://github.com/alxwest/ym-lean/issues/40
[issue-uv]: https://github.com/alxwest/ym-lean/issues/41
[issue-stress]: https://github.com/alxwest/ym-lean/issues/42
[issue-gap]: https://github.com/alxwest/ym-lean/issues/43
[issue-groups]: https://github.com/alxwest/ym-lean/issues/44
[issue-countermodel]: https://github.com/alxwest/ym-lean/issues/5#issuecomment-7016339008
