# YM4 against the ym-lean specification

At revision `c7fef8b21b5846e1b5806a7d4f915737b9130c27`, YM4's long-form outline states a
conditional construction of a nontrivial scalar `tr(F²)` sector for Wilson `SU(2)` on
full four-dimensional spacetime. The unresolved interacting estimates, the scope of
the observable family, the all-group quantifier and the physical mass gap are distinct
obligations. Both native verifier modes report `PROOF_NOT_SUBMITTED` for this review.
[YM4 source tree](https://github.com/alxwest/Yang--Mills-LLM-experiment/tree/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4)
· [Theorem 0 and introduction][main-theorem]

## Source statement and proof status

- Theorem 0 uses periodic Wilson tori, an infinite-volume torus limit at each fixed
  spacing and bare coupling, then a common continuum subsequence along first-passage
  cutoffs at sufficiently small reference coupling. The canonical-components result
  gives the selected phases Euclidean invariance, reflection positivity, quantitative
  growth on diagonal-flat Schwartz tests and clustering. A component can retain a
  finite one-point mean after reference-state subtraction. The long-form scalar
  reconstruction uses corrected Osterwalder–Schrader reconstruction to obtain a local
  Hermitian scalar Wightman field with positive energy, a cyclic representation and a
  unique vacuum in a component. The standalone CL manuscript retains this scalar scope
  and the uniform source, running and physical comparison hypotheses.
  [Continuum correlations][continuum] · [Canonical components][phases] ·
  [Scalar reconstruction][reconstruction] · [CL abstract and introduction][cl] ·
  [Osterwalder–Schrader II, §IV.1][os-ii]
- The scalar route needs admissible first-passage data from the uniform multiscale
  induction, the rooted ordinary-source input D1 and the actual interacting two-point
  and running-normalization inputs F2–F3, with the same test classes and uniformity over
  the periodic Gibbs states used for the phase construction. H4 explicitly leaves the
  verification of D1 and the interacting short-distance law open. The assembly overview
  lists open work on mixed-scale backgrounds, substitution and retained histories,
  actual coefficients and Gaussian normalization, and the conditional-law comparison.
  Its completion marks describe deductions under each box's stated premises.
  [Dependencies][dependencies] · [D1][d1] · [F2][f2] · [F3][f3-f4] ·
  [H4][h4] · [Assembly overview, §13][assembly-status] · [Physical two-point draft][fp]
- The shorter `YM4_sketch_draft` states a Euclidean action-density target with the
  quantitative growth and clustering properties. The reconstruction findings in this
  review refer to the long-form outline. The source tree at the pinned revision contains
  the manuscripts as TeX and PDF, so there is no upstream Lean declaration to import or
  submit to the inspector. [Short sketch, Euclidean action-density construction][short-sketch] ·
  [YM4 source tree](https://github.com/alxwest/Yang--Mills-LLM-experiment/tree/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4)

## Requirement crosswalk

The comparison uses the ym-lean definitions at `fee9fa0f18040e9bf4af7f948ab3576c6cf2ba76`.
The native existence target requires `Nonempty (FilteredExistenceCandidate G)` for
every `CompactSimpleGaugeGroup.{u}`, meaning an actual compact connected Lie group
with simple Lie algebra. The full target asks for a `FilteredGeneratedCandidate`
for every such group. Both use the same group-dependent observable, UV, OPE and stress
requirements. The full candidate additionally requires a positive finite gap for the
actual Hamiltonian. [Existence definition][existence] · [Full target][full-target] ·
[Admission contract](../CERTIFICATION.md) · [Jaffe–Witten, §4][jw]

| Native requirement | YM4 evidence and remaining bridge |
| --- | --- |
| **Actual gauge group and universal existence** · [`CompactSimpleGaugeGroup`][group] | The construction fixes `SU(2)` in its defining representation. The checked finite action below uses a group isomorphism to precisely this matrix group. The weight takes different values on `I` and `-I`, so it cannot descend as the same function of the quotient holonomy in `SU(2)/{±I}`. Any extension to other group forms needs a construction or an appropriate continuum transport. [Wilson measure][wilson] · [Lean comparison][lean-audit] |
| **Full spacetime and physical QFT** · [`WightmanAxioms`][wightman] | The volume-first limit targets all of `ℝ⁴`. Conditional scalar reconstruction gives a separable Hilbert space, field domains, tempered scalar distributions, locality, covariance, a cyclic vacuum and the forward spectral condition. The formal comparison needs that reconstruction, test-space and time-coordinate transport, and the native operator and domain clauses on the same cyclic phase. [Canonical components][phases] · [Scalar reconstruction][reconstruction] |
| **Hamiltonian and vacuum** · [`generator_domain` and `generator_action`][wightman] | The Euclidean Hilbert space carries a self-adjoint contraction semigroup `e^(−tH)`. The pure component has `ker H = ℂΩ`. Identify this generator with the full self-adjoint generator of real-time translations under the reconstruction, with its full derivative domain and the same vacuum. Use the selected phase; the scalar mixture can have a larger zero-energy space. [Continuum correlations, (b)(v)][continuum] · [Canonical components][phases] · [Spectral question][h4] |
| **Nontriviality** · [`HasFieldExcitation`][nontriviality] | Under F2–F3 the connected two-point function for prescribed nonnegative separated bumps has a strictly positive lower bound. With unit-integral bumps it is comparable to `d⁻⁸ / log²(1/d)` on `ℝ⁴`. After Hilbert-space identification, a nonzero connected pairing implies a non-vacuum vector, and Wightman cyclicity gives the native field-word excitation. The optional positive four-point comparison has extra hypotheses and is confined to fixed tori. [Two- and four-point clauses][two-point] · [Canonical components][phases] · [Lean comparison][lean-audit] |
| **Yang–Mills identification and observable dictionary** · [`RenormalizedCompositeMap.Compatible`][composites] | Wilson provenance and the normalized action density are specified. F4 identifies further work on joint continuum readouts, gauge identities and a sufficient observable family. Finite Wilson trace words separate cutoff gauge orbits and the manuscript gives conditional joint extension criteria. The native candidate needs the compatible map of curvature and covariant-derivative labels, with its identities, mixing and cyclicity on the same physical space. [F4][f3-f4] · [Joint gauge-observable extension][joint] |
| **UV matching and auxiliary prescription** · [`GeneratedMatching` and `GeneratedWordBridge`][matching] | The leading inverse-coupling law and two-sided scalar estimate give asymptotic-freedom evidence. On `ℝ⁴` the multiplicative two-point error is bounded between positive constants. The native target requires coefficient and physical-word remainders through every finite coupling order on the specified test classes, with the same label, scale and coupling normalizations. The lattice multiscale construction needs a comparison with the native fixed flow, BRST/BV, Ward and Callan–Symanzik data. The manuscript's all-orders angular closure concerns the number of scalar insertions and Euclidean covariance. [Two-point clauses][two-point] · [All-orders angular closure][angular] · [Native Ward family][ward] |
| **OPE, full kernels and contact terms** · [`WeakMultiExpansion`][ope], [`WightmanVacuumKernels`][kernels] | The Euclidean scalar moments extend to tests flat on every coincidence diagonal. Conditional reconstruction gives full tempered Minkowski distributions for the scalar words via boundary values. An extra distribution supported on a diagonal is invisible to the displayed Euclidean test space. The native comparison needs the joint full Minkowski kernels, their continuation on compact ordered tests and the same-field OPE with scaling remainders, labels and separated spectators. The native contact conditions constrain the generated local extensions. [Scalar reconstruction][reconstruction] · [Native word continuation][words] · [Native Ward family][ward] |
| **Stress tensor and trace identity** · [`StressTensorData.Compatible`][stress], [`GeneratedSector.same_stress`][matching] | The manuscript studies an exact finite-lattice displacement Ward identity with contact and shell-flux terms, and a first tracefree diagonal stress response on a regular trajectory. These supply possible inputs to a transport. The native target needs the continuum tensor on the reconstructed space, graph-core global charges giving its translations, and the exact vacuum-centered trace identity with the same beta function and curvature-square field. [Regular stress response][stress-response] · [Finite-lattice Ward identity][displacement] · [Native trace equation][trace] |
| **Positive finite spectral mass** · [`HasPositiveFiniteMass`][spectrum] | The canonical components have positive energy and a polynomial cluster bound. H4 leaves open a positive lower edge above zero. The full target needs an interval `(0, Δ)` free of spectrum and some positive spectral value for the same physical Hamiltonian. A gap for a constrained lattice inverse, or even a gap on the scalar subspace, leaves the lower edge of an enlarged physical space to be checked. [H4][h4] · [Manuscript's spectral example][spectral-example] · [Lean comparison][lean-audit] |

The bridge to native existence would start with a single admissible continuum sequence
and a selected phase, then identify the joint observable and generated matching data
on that phase's physical Hilbert space and extend the construction or transport to every
native group. The full claim additionally requires spectral separation on each resulting
physical space. A theorem about the scalar sector, even if all its stated analytic
inputs are supplied, would still leave these obligations. Both implications between
the source conclusion and the complete native targets remain open in this audit.
The scope of this review is the stated conclusions, dependencies and selected
consequences. Full independent verification of the multiscale proofs and
reconstruction premises remains open.

## Lean checks and verifier result

[The comparison file][lean-audit] elaborates with Lean 4.32.0. It checks the exact
finite Wilson plaquette weight and orientation invariance, the failure of the weight
to descend to the central quotient, the connected-pairing implication for native
field excitation, and the equivalence between a full candidate and a native existence
candidate with a positive finite gap on its own Hamiltonian. It also checks the
manuscript's spectral example. The probability measure with density `E exp(−E)` on
positive energies has Laplace transform `(1+t)⁻²` for `t ≥ 0`, yet has support
`[0, ∞)`, which fails `IsMassGap` at every `Δ`. This is a counterexample to a spectral
inference from polynomial decay. The spectrum of the YM4 model remains a separate
question. [Manuscript example][spectral-example]

Run from the repository root after setting up the [pinned toolchain](../lean-toolchain).

```sh
lake build +YangMills.ExistenceOnly +YangMills.PeriodicLattice4 \
  +Mathlib.LinearAlgebra.UnitaryGroup +Mathlib.MeasureTheory.Measure.Support \
  +Mathlib.Probability.Distributions.Gamma
lake env lean integrations/ym4/Comparison.lean
python3 scripts/verify_submission.py --claim existence --report .lake/ym4-review/existence.json
python3 scripts/verify_submission.py --claim yangmills --report .lake/ym4-review/yangmills.json
```

Both verifier invocations passed their compiled target-shape checks and exited `2`
with `PROOF_NOT_SUBMITTED`. The proof inspection status was `not_run` and every
certificate flag was `false`. The Lean comparison lemmas use only the allowed
foundations `propext`, `Classical.choice` and `Quot.sound`.

[main-theorem]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=1
[wilson]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=2
[continuum]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=21
[phases]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=25
[two-point]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=23
[dependencies]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=26
[d1]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=31
[f2]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=34
[f3-f4]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=36
[h4]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=41
[assembly-status]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_assembly_overview.pdf?raw=true#page=19
[short-sketch]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_sketch_draft.tex#L167-L230
[stress-response]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=943
[angular]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=1164
[displacement]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=1164
[joint]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=1248
[reconstruction]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=1260
[spectral-example]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=1264
[os-ii]: https://projecteuclid.org/journals/communications-in-mathematical-physics/volume-42/issue-3/Axioms-for-Euclidean-Greens-functions-II-with-an-Appendix-by/cmp/1103899050.pdf#page=7
[existence]: ../YangMills/ExistenceOnly.lean
[full-target]: ../YangMills/YangMillsSpecification.lean
[group]: ../YangMills/GaugeGroup.lean
[wightman]: ../YangMills/QFT/Wightman.lean
[nontriviality]: ../YangMills/Nontriviality.lean
[composites]: ../YangMills/CompositeFields.lean
[matching]: ../YangMills/FilteredQuantumRG.lean
[ward]: ../YangMills/LocalWardFlowFamily.lean
[ope]: ../YangMills/MultiOperatorProductExpansion.lean
[kernels]: ../YangMills/WightmanVacuumKernels.lean
[words]: ../YangMills/VacuumWordContinuation.lean
[stress]: ../YangMills/StressTensor.lean
[trace]: ../YangMills/FilteredGeneratedCandidate.lean
[spectrum]: ../YangMills/Spectrum.lean
[lean-audit]: ../integrations/ym4/Comparison.lean
[cl]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/CL/YM4_CL.tex#L107-L182
[fp]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/FP/YM4_FP.tex#L107-L126
[jw]: https://www.claymath.org/wp-content/uploads/2022/06/yangmills.pdf#page=6
