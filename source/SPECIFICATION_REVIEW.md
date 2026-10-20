# Specification review, 20 October 2026

**Outcome: partial implementation; the requested complete fixed Yang–Mills
proposition has not been completed.** This is a definition/equivalence gap,
independent of whether an existence proof is available. No full target or exact
full-target proof admission has been introduced.

The existing target `YangMills.QFTExistenceAndMassGap` remains a necessary
QFT-only existential. Its proof would not establish Yang–Mills identification.

## Integrated mathematical design and its unresolved parts

For each source-admissible compact simple G, the intended witness has one
Hilbert space, one vacuum, one common invariant field domain, and one strongly
continuous spacetime representation. The Hamiltonian is the full derivative
generator of its time translations. All local composite fields, correlation
functions, and the stress tensor must be built on these same data.

The classical labels must come from the actual G-adjoint-invariant curvature
jet polynomials, with identities evaluated on actual smooth connections.
Renormalized quantum correspondence must allow finite mixing among appropriate
composites. It cannot be an arbitrary field-index labelling, a zero map, a naive
polynomial/operator bijection, or an independent classical algebra next to Q.
The current concrete classical quotient is progress toward these labels, not
that correspondence.

A fixed perturbative pure Yang–Mills calculation must determine the required
coefficient system from the actual Lie bracket and action normalization. Its
admissible finite renormalizations and composite mixing must be defined and
shown to preserve the required meaning. This does not require choosing a unique
formalization or forcing every construction to use one regulator. It does
require a justified sufficient presentation before any proof author supplies
witnesses. **This fixed perturbative calculation and fidelity argument remain
absent.**

The same Q's correlations must then satisfy the resulting UV scaling laws and
OPE collision expansions. For each justified finite truncation, the subtraction
and remainder must have fixed meanings, including test domains, spectators,
running coupling, logarithms, mixing, and the topology of convergence. The new
`TestwiseExpansion` fixes only a finite scalar testwise remainder relation; it is
not a completed OPE or prescribed UV condition. The checked negative control
`selfSelectedExpansion` proves why existentially selecting its terms is vacuous.

The stress tensor must be a normalized local composite of this same theory,
with distributional symmetry/conservation and a precise connection to its
translation generators, including any domain, cutoff-limit, contact-term and
improvement qualifications. No such complete definition is implemented.

Only after these fixed relations and the cited-QFT adequacy argument exist can
the outer proposition combine them for every G. Non-vacuum excitations alone
cannot replace Yang–Mills identification. No missing existence proof is listed
as a missing definition in this design.

## Implemented mathematics

| Requirement | Concrete addition | Remaining boundary |
|---|---|---|
| General classical observables | `InvariantJetPolynomials.lean`: all finite multivariate jet polynomials; actual differentiated conjugation; invariant subalgebra; weighted filtration; equality-on-connections quotient | Geometric gauge covariance and presentation-equivalence; quantum mixing/correspondence |
| Actual time-translation H | `hamiltonian_domain_unique`, `hamiltonian_action_unique` | Standard analytic equivalences remain to be supplied |
| Unbounded field domains | `field_graph_limit_zero` derives smeared-field closability | Multi-point tempered-distribution kernel and cited-standard adequacy |
| Finite physical mass | `hasPositiveFiniteMass_iff`, `mass_le_positive_spectral_value`, `mass_isMassGap` | No mass-gap existence proof is requested here |
| Short-distance quantities | `dilateTest`, same-Q `scaledVacuumNPoint`, finite subtraction and quantified `TestwiseExpansion` | Fixed perturbative predictions and justified UV/OPE topology |
| Arbitrary-asymptotic-data attack | `selfSelectedExpansion` holds for every Q if terms can equal its correlator | The coefficient anchor is still missing; the attack is documented, not solved |

The new lemmas add no assumptions to the existing QFT-only target. The
classical and UV fragments are imported and transitively audited in the default
library build, but are not represented as a completed Yang–Mills predicate.

## Fidelity decisions and risks

- Wightman is the selected presentation, subject to exact cited-standard
  adequacy. A second OS construction is not imposed. If an OS route is later
  chosen, the corrections in OS II must be respected.
- The connected compact-simple-Lie-algebra group convention includes finite
  central quotients; its exact source coverage still needs a fidelity argument.
- Differentiated conjugation fixes the group dependence of classical
  invariance. Independent jet coordinates are quotiented by equality on actual
  smooth connections. Surjectivity onto all intended local invariants and
  coordinate independence are supporting equivalence work, not established here.
- Classical engineering dimension is not an anomalous quantum dimension.
  The filtration is vocabulary guided by footnote 1, not an additional exact
  quantum filtered-isomorphism theorem.
- Normalized test dilation uses exponent four for the smearing Jacobian.
  No field dimension, anomalous logarithm or prescribed OPE coefficient is
  silently inferred from this exponent.
- No norm-convergent operator OPE, unrestricted composite-spectator rule,
  preferred scheme/lattice/regulator, confinement, one-particle eigenstate,
  or independent non-Gaussianity criterion has been added.

## Exact unresolved work and approaches rejected

The central unresolved issue is a fixed, group-sensitive renormalized
perturbative coefficient construction and its mathematical relation to the
same nonperturbative local fields. This affects §4's Yang–Mills identification,
local correspondence, UV, stress-tensor and OPE clauses. The source analysis,
Yang–Mills review and adversarial review specify the subsidiary gaps.

Approaches considered and rejected as completions:

1. Quantifying G without quantum dependence: the existing reuse-one-QFT lemma
   proves insufficiency.
2. Adding a genuine G-dependent classical/lattice sector beside Q: the existing
   unlinked-check lemma proves insufficiency.
3. Restricting classical observables to quadratic pairings: replaced with the
   general invariant-jet algebra, but still no quantum correspondence follows.
4. Giving an arbitrary linear correspondence/mixing matrix: permits zero or
   unrelated free-field images and has no perturbative anchor.
5. Supplying arbitrary asymptotic coefficients: the new checked self-selection
   lemma shows zero remainder for any Q.
6. Imposing a Wilson-lattice limit or one preferred renormalization prescription
   universally: no sufficient fidelity argument was obtained, so not imposed.
7. Using the beta-function sign alone: omits composite mixing and prescribed
   OPE singularities and cannot define the full source requirement.

Concrete next work: formalize one admissible perturbative Yang–Mills
presentation with graph amplitudes, gauge/ghost or equivalent invariant data,
local counterterms, composite insertions and symmetry identities; derive its
G-dependent beta/anomalous/OPE system; define allowed scheme transformations;
then state and justify the corresponding distributional short-distance and OPE
conditions on the same Q. In parallel, finish geometric jet covariance and
cited-Wightman kernel/spectral equivalences. These are definition/equivalence
projects, not a request to prove Yang–Mills existence.

## Admission and verification

`python3 scripts/verify_submission.py --claim specification` assesses readiness
without requiring a proof file. For the present definitions it exits 2 with
`SPECIFICATION_INCOMPLETE`. Full Clay admission continues to exit 2 with
`CLAY_CERTIFICATION_BLOCKED`, regardless of manifest coverage labels.

The JSON report separately records `specification_readiness`,
`proof_submission_status`, `kernel_verification_status`, `semantic_review_status`,
and `external_acceptance_status`. `admitted_target` is populated only after an
actual QFT-only proof passes the independent exact-type/transitive-axiom audit.
No automated status or agent consensus establishes physical fidelity or CMI
acceptance. No existence proof was submitted in this task.

For clause-by-clause source locations and definitions/equivalence versus proof
work, see [SOURCE_ANALYSIS.md](SOURCE_ANALYSIS.md). For domain/framework review,
see [QFT_REVIEW.md](QFT_REVIEW.md). For central Yang–Mills issues, see
[YANG_MILLS_REVIEW.md](YANG_MILLS_REVIEW.md). The independent attack report is
[ADVERSARIAL_REVIEW.md](ADVERSARIAL_REVIEW.md).


## Validation performed

In the requested checkout, `python3 scripts/check_proofs.py` completed with
exit 0 under pinned Lean 4.25.0. It passed 21 verifier unit tests, the default
build with transitive axiom audits (2739 jobs), 15 proof-audit regressions, and
both independent kernel-inspector adversarial rejections (wrong target and
`sorryAx` despite spoofed local audit syntax). The readiness assessment returns
expected exit 2, `SPECIFICATION_INCOMPLETE`, without requiring a proof file.
The patch passed the whitespace and reverse-applicability checks. These checks
validate the implemented fragments and admission boundaries; they do not
establish the missing semantic fidelity argument or complete the specification.
