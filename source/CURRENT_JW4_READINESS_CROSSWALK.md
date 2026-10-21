> Current disposition: the central source/action, canonical high-UV, literal Fourier/Taylor, integrated/pointwise normalization, same-field stress and insertion/OPE uniqueness bridges are proved and strictly compiled. Review conditions below are retained as the original decision record; the final combined verification record controls activation. The malformed-proof reporting finding was corrected with six added regressions. No existence proof or external acceptance is asserted.

# Current Jaffe--Witten §4 readiness crosswalk

Reviewed object: CURRENT PRIMARY `FilteredGeneratedCandidate` and its imported
fixed definitions, not the older homogeneous candidate or historical gap
paragraphs in the manifest. Review date: 2026-10-20. Normative source is the
pinned repository `source/yangmills.pdf`, Jaffe--Witten §4, printed p.6;
§§1 and 3 supply the action and QFT context. Official copy:
https://www.claymath.org/wp-content/uploads/2022/06/yangmills.pdf .

The canonical high-UV determinacy application, literal reduced Fourier/Taylor
recovery, and correction of the 45 accidental analytic smoothness orders
are complete and strictly compiled. Their combined verification is recorded
in VERIFICATION_RECORD.md.
The separate review of the actual fixed Gaussian prescription is resolved
by the direct same-action gauge-fixing proof and exact coefficient/contraction
dictionary described below. Stress dictionaries use active4/frame4; cutoff5
is retained only for the BRST response/anomaly targets.
No existence proof is assumed or required for this assessment.

## Recommendation

The proposed closed candidate is a defensible reviewed specification; the
central mathematical bridge checks have passed individually. The concrete Gaussian
comparison is resolved by the exact same-action and coefficient-order
arguments below. I do not identify
an additional substantive missing definition/equivalence gate beyond those
concrete checks. Activation requires the combined outcomes recorded in VERIFICATION_RECORD.md.
Leaving admission blocked merely for “universal
cohomology classification,” “beta uniqueness,” “generated transport existence,”
or an unspecified further “framework equivalence” would conflate proof
construction with specification readiness.

This recommendation concerns mathematical meaning and a fixed reviewed
sufficiency argument. It does not assert a Yang--Mills existence theorem,
external expert endorsement or CMI acceptance. The exact declaration and
verifier can be enabled only through the repository's separately reviewed
admission process; the proposed declaration's current name/status is not
itself evidence that it is admitted.

## Clause-by-clause crosswalk

| Source clause / registry ID | Current mathematical meaning | Readiness assessment under stated assumptions |
|---|---|---|
| Every compact simple G / `group` | Universe-polymorphic `CompactSimpleGaugeGroup`; actual compact connected finite-dimensional Lie group, simple tangent Lie algebra, actual Ad/bracket in the engine and observable algebra. | Definition is appropriate for the conventional compact simple Lie-group terminology. All finite central quotients are allowed; no simply-connected or matrix-group restriction. See global scope below. |
| Four-dimensional R4 / `spacetime` | `Spacetime = Fin 4 → ℝ`, full Schwartz fields, full Poincare translations, all-cutoff perturbative auxiliaries with actual continuum limits. | Complete meaning; neither a finite box nor a lattice is substituted for the physical theory. |
| Cited QFT strength / `qft-axioms` | Same positive complete separable Hilbert Q, common dense invariant domain, tempered fields/full vacuum kernels, adjoints, local commutativity, Poincare covariance/continuity, unique invariant vacuum, exact joint translation Fourier support, actual self-adjoint Hamiltonian with full generator domain/action. | Standard bosonic observable Wightman formulation, with presentation arguments below. No need to impose both Minkowski and OS reconstruction or add a PVM datum. Full [45] chapter access qualification remains explicit. |
| Yang--Mills for G / `ym-identification` | Actual invariant form/color frame, fixed shifted-B/BV action and actual group vertices, same generated flow/Ward/lift/CS/word/OPE/stress equations. All witnesses occur in one assembled sector on the same physical Q. | Not the earlier unused-G or unrelated-QFT construction. The direct same-action and exact coefficient-order dictionary provide the concrete source sufficiency argument. A new universal classification theorem is not separately required by this definition. |
| Gauge-invariant curvature differential polynomials / `gauge-observables` | Full Ad-invariant jet-polynomial algebra, actual connection evaluation, quotient by identities on connections, linear renormalized composite map C in Q. Descendants, covariance, reality, identity and composite-only cyclicity are mandatory. Corrected quantum lifts and output recovery use the same generated complex. | Covers arbitrary invariant tensors, not only quadratic pair contractions. Gauge-covariant curvature jets transform by simultaneous Ad; invariant polynomials therefore have the required classical gauge-invariant meaning. No bijection with quantum operators is asserted. |
| Dimension-filtered expectation / `renormalized-filtration` | Actual finite classical filtration/bases and filtered finite RG mixing, with possible quantum relations. | Guidance is respected without turning footnote 1 into quantum injectivity, a cohomology bijection or a separate exact filtered-isomorphism gate. |
| Short-distance correlation predictions / `ultraviolet` | All-order weak small-distance remainders for the SAME analytically continued vacuum words, same engine-derived finite coupling/loop coefficients, actual running coupling tending to zero, actual label transport with jets from same full CS normalization. | A concrete asymptotic statement, not an equality of a divergent series at fixed coupling. Smooth beta/gamma/stress completions may contain flat contributions; jets are fixed to every order. No unique resummation is required. |
| Stress tensor / `stress-tensor` | Same-C local tensor, degree four, conservation/symmetry/covariance, charge limits on graph cores to the actual translation operators, same generated tree symbol and quantum cocycle/dictionary, same RG equations and centered trace anomaly. | Actual physical generator identity rules out an arbitrary tensor named “stress.” Identity shifts do not impose absolute vacuum energy; both trace-anomaly sides use the same vacuum centering. The source/canonical curvature normalization is part of the resolved same-action dictionary; the tensor mixing dictionary itself uses degree four. |
| OPE and prescribed singularities / `ope` | Actual same-field multi-kernels fixed on dense tensor products; all-degree simultaneous-cluster weak OPE with separated physical spectators; separate coefficient scaling bounds; every arity's prescribed coefficients generated by the same extractor, plus local contact/partial-diagonal equations and Wick continuation. | Prescribed coefficients cannot be redefined to fit an unrelated field product. Remainder and coefficient singularity bounds are independent, preventing redundant-field cancellation from hiding arbitrary coefficients. This is an asymptotic local expansion, not convergence of the operator series. |
| Nontrivial theory / `nontrivial` | Positive finite physical spectral mass excludes a vacuum-only model and gives actual field excitations; C-only cyclicity, same-group generated word matching and physical stress charges identify these with the Yang--Mills observable theory. | No extra Gaussianity or one-particle criterion is needed. Finite mass alone would not identify Yang--Mills; here it is combined with the actual-G UV/word links. |
| Positive finite physical mass / `physical-gap` | `HasPositiveFiniteMass` for the SAME Hamiltonian's resolvent-defined real spectrum; some positive gap and bounded set of admissible gaps; mass is their supremum. Actual generator domain/action prevents substituting a restriction. | Includes continuous spectrum; excludes empty/vacuum-only spectra by the finite supremum condition. Proved equivalence to a positive spectral value plus a gap and positivity of the supremum give precisely the required finite positive mass. No isolated eigenstate is required. |
| Existence for all G / `universal-existence` | Closed `∀ G, Nonempty (FilteredGeneratedCandidate G)` with all group/theory/auxiliary witnesses bound. | Complete logical shape. Producing those witnesses and proving their conditions is the unsolved existence task, not missing definition. Reusing a carrier or even a theory for suitable groups is not forbidden; each group's fixed equations must hold. |

## Global groups and local observable scope

The binder includes every connected compact Lie group with simple Lie
algebra, including all allowed quotients of its simply connected form by
finite central subgroups. Lie-algebra simplicity is intentionally different
from simplicity as an abstract group. Compact finite-dimensional Lie groups
have the ordinary Hausdorff/second-countable manifold presentation; compact
chart covers justify the latter, and the extra finite smoothness instance
is a consequence of smoothness. The universe is not restricted to small
carriers.

Central quotients can have the same Ad-invariant local algebra and same
perturbative coefficients on R4. This does not invalidate the binder or
same-object link: the source's specified endpoint concerns these local
observables, not a prescribed theory of Wilson/'t Hooft lines on all bundles
or all manifolds. No assertion that all global-form quantum theories are
equivalent follows. Disconnected extensions of a simple identity component
are not part of the conventional connected compact simple Lie-group usage;
if that unconventional broader interpretation were intended, the group
class would have to be enlarged explicitly.

## Complete QFT presentation comparison

The source permits an axiom system at least as strong as the cited standards.
The current Minkowski formulation supplies the full Wightman hierarchy:
`WightmanVacuumKernels` contains continuous functionals on every full
S(R^(4n)), fixed by the SAME operator words on a dense tensor span. Positivity
comes from the positive Hilbert inner product. The spectrum condition is
exact annihilation of Fourier tests outside the future cone for every
matrix coefficient of the same unitary translations; this is a standard
joint spectral-support formulation. Separate SNAG/PVM construction would
reprove its representation, not fill missing meaning. The time generator's
full domain/action and self-adjoint graph fix the operator whose spectrum
enters the gap.

Strong test-function continuity on a fixed domain vector follows from the
usual weak domain-matrix continuity by the closed graph theorem on Schwartz
and Hilbert spaces: testing a graph limit against every vector in the dense
domain identifies its limit. Thus it is not an added energy bound. A cyclic
polynomial domain gives a common invariant domain for the selected countable
family. Countability follows from finite bases of the classical invariant
filtrations and finite mixing, rather than separability alone. Integer-spin
observable covariance allows the Lorentz cover to descend: its central
kernel fixes the vacuum and every observable-word vector, hence all H by
cyclicity.

The checked small-Hilbert transport preserves the full QFT, vacuum hierarchy,
resolvent spectrum and mass. The rest of the candidate transports by the
same unitary: C is conjugated on its common domain, multi-kernels have their
two vector arguments conjugated, stress generators and cores are conjugated,
and scalar generated/RG/continuation data are unchanged. All scalar limits
and centered onepoints are identical. A full Lean outer transport function
is useful packaging, not another analytic hypothesis or essential fidelity
gap.

Primary comparison actually consulted: Streater's coauthor exposition,
https://www.scholarpedia.org/article/Wightman_quantum_field_theory , axioms
II--III and Theorem 4; Osterwalder--Schrader I, §4.2 pp.94--95, and II's
correction of Euclidean reconstruction hypotheses. The full [45] book's
axiom chapter was NOT directly accessed: its publisher preview reaches
front matter/contents only. This report does not claim otherwise. The
explicit mathematical comparison above and the primary coauthor/OS sources
support the chosen standard formulation; the access limitation is a source
provenance qualification, not evidence of an omitted axiom. Requiring a
separate OS reconstruction when a complete Minkowski model is supplied
would add a method rather than strengthen a missing endpoint axiom.

## Formal coefficients versus actual physical asymptotics

The Gaussian prescription is an auxiliary coefficient construction, not the
nonperturbative construction method required of every solution. Its finite
local marginal data represent finite scheme choices. Full Ward and CS
conditions then constrain these data simultaneously; no theorem saying that
all arbitrary choices can be restored is presumed. The source equations to
compare are FHH 1511.09425 §III.C Eq.(91), Eq.(95), Table II, and FH 1603.08012
§2 Eqs.(2.25)--(2.27), including the distinct integrated-background versus
pointwise-insertion boundaries. The proved canonical and literal recovery
bridges ensure this normalization really extracts the actual graded local
coefficients, including phases and factorials.

All-order remainders are imposed only after actual RG transport and canonical
scaling, on fixed compact off-collision tests; the coupling tends to zero.
The series is finite at each retained order by graph grading. Exact physical
OPE coefficients and words are not merely the formal coefficients renamed:
they are tied to the same Q/C fields and satisfy these limits. Their
nonperturbative flat or power-suppressed contributions are allowed. Actual
OPE remainders further control engineering truncation independently of the
perturbative asymptotics. Contact extensions are finite local maps on the
same lower-arity amplitudes, not arbitrary spectator-dependent completion.

The trace condition uses beta from that same normalization/completion and
F_source^2. The factor beta/(2g^3) becomes beta/(2g) with canonical curvature
F_source=g F_canonical. Centering both actual fields is equivalent to the
anomaly plus its computed vacuum identity scalar; it does not impose zero
absolute vacuum stress or exclude legitimate identity mixing. The selected
stress charge profile can be changed without changing the actual generators,
so identity shifts do not create an extra source obligation.

## Resolved review conditions; what is not a gap

1. The strict rebuild of the outer-order correction passed: outer `⊤` in
   this pinned ContDiff API is analytic order, whereas `∞` is C-infinity.
   The former stress condition forced a convergent germ; the correction
   preserves genuine Wightman holomorphy.
2. Canonical high-PDE, literal Fourier recovery, integrated/pointwise
   normalization and insertion/OPE uniqueness bridges are proved and
   strictly compiled; their audit is included in the combined checks.
3. The specific Gaussian, shifted-B, Grassmann-sign, projector,
   source-normalized Gamma, insertion and Wick dictionary review is
   resolved by the same-action and coefficient-order arguments below.
   The final independent re-review identified no concrete remaining blocker.

No additional necessary gap is established by this review.
One must not replace these concrete checks with a demand to construct the
Ward-restored flow, solve the continuum problem, classify all cohomology,
prove beta-representative uniqueness or prove every valid presentation
admits a unique scheme. Those are different claims. If the finite projected
normalizations were ever substituted for the full Ward/CS identities, a
restricted classification/extension theorem could become necessary; the
current candidate retains those full concrete identities as obligations.
Historical manifest/CERTIFICATION gap text about absent UV meanings,
unproved interacting nilpotency, or unlinked physical stress is therefore
not a description of the current candidate and must not be used as fresh
mathematical evidence of incompleteness.

### Resolved concrete dictionary issue

FHH printed p.16 Eq.(67), in order (A,c,barc,B), displays the ghost covariance
block [[0,-C],[+C,0]], whereas `basicCovariance` has [[0,+C],[-C,0]]. This is
now addressed by the exact finite coefficient-order comparison, rather than
a guessed antighost phase. FHH Eq.(86)'s successive displayed left partials
act with the rightmost derivative first; the implementation's derivative
list is chronological. Reversing that list gives the source order. The
proved simultaneous covariance transpose and derivative-slot reversal leave
the complete Gaussian/flow contractions unchanged. The exact Fourier bridge
uses the same momentum reflection, and applies to the full master polynomial,
including antifields. `SourceCovarianceOrder` supplies these concrete laws.

The actual component action is independently justified by the proved
`masterDensity_gaugeFermion_curvature` and
`fullAntifieldDensity_characteristic`: it is the actual curvature-square
Yang--Mills action plus the actual ST gauge-fermion variation and all
characteristic antifield couplings, modulo explicit total divergences.
The full same-action CME and pointwise/quotient nilpotency are proved.
This establishes a coherent standard component BV gauge fixing without
pretending to have derived an unprinted phase conversion from every total
form in FHH Eq.(47). FHH explicitly makes s anticommute with odd forms and
exterior d; a naive scalar reading was never a legitimate discrepancy proof.
A stronger literal total-form pullback equality is not claimed. The direct
gauge-fixing construction and exact computational dictionary suffice for
this fixed prescription.

### Stress filtration correction

`StressSourceDictionary.Compatible.degree` requires every dictionary label
to have engineering dimension at most four. Using the entire active5 basis
there would instead force genuine dimension-five descendants to have degree
at most four, even when their stress coefficients vanish. The corrected
current and older homogeneous assemblies use active4/frame4 for the stress
source dictionary and its RG frame. The degree-five BRST response/possible
Ward anomaly target is different: s raises FHH engineering dimension by one,
so that target correctly stays at five. No extra restriction on the physical
stress is introduced by fixing this accidental dictionary contradiction.

### Final scope verdict

The concrete corrections and canonical/Fourier bridges are integrated and
strictly compiled. This review identifies no remaining
unsatisfied *semantic condition*. Constructing a candidate satisfying the
fixed full Ward/CS/continuum/physical matching equations remains the existence
task. Unproved optional comparison theorems must not be treated as new
hypotheses. This verdict is a reviewed sufficiency interpretation of the
source, not an assertion that the source uniquely selects this presentation
or that a Yang--Mills existence proof or external certificate has been obtained.
