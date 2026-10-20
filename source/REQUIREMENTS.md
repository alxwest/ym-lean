# Jaffe–Witten source-to-Lean verification map

**Canonical file:** [`source/yangmills.pdf`](yangmills.pdf), *Quantum Yang–Mills
Theory* by Arthur Jaffe and Edward Witten, identical in content and bytes to
the [Clay-hosted PDF](https://www.claymath.org/wp-content/uploads/2022/06/yangmills.pdf).

**Source byte identity:** SHA-256
`3558403ca14c11e382f73a09e548222708540bfdf478cf96aa11c52d43e23e09`.
The repository pins this digest in `scripts/verify_submission.py`.

**Normative text:** §4, printed page 6 / zero-indexed PDF page 5.
§1 and §3 supply the classical and quantum-field definitions.
Footnote 1 explains that a naive bijection between classical local polynomials
and quantum local operators is wrong: renormalization mixes operators.
The PDF describes a correspondence between dimension-filtered spaces as
an *expectation*, not as a separately stated theorem. That observation
guides interpretation; requiring a specific exact filtered isomorphism
as an additional acceptance condition would overstate the text.

## Direct formalizations and interpretive formalizations

The PDF's directly translatable formulae are in
[YangMills/PDFLiteral.lean](../YangMills/PDFLiteral.lean),
with exact source markers in docstrings. The distinction between these,
cited standards, interpretive models and optional constructions is
documented in [FORMALIZATION_LAYERS.md](FORMALIZATION_LAYERS.md).

The machine-readable inventory now marks each clause on **two
independent axes**: acceptance_role (is this a required part of
the statement?) and formalization_layer (how much definition
work is needed to represent the phrase faithfully in Lean?).
Neither label constitutes a proof or an assumption.

## Clause roles and authority

Eleven inventory entries track the Section 4 theorem and explanatory
requirements; `renormalized-filtration` records footnote 1's interpretive
expectation only. This is a **source crosswalk**, not twelve independent
axioms. The verifier fixes these roles and rejects attempts to promote a
suggestion into a mandatory acceptance condition.

See [STATEMENT_POLICY.md](STATEMENT_POLICY.md) for the governing rule.

## Complete clause inventory

| ID | From the PDF | Implemented in Lean? |
|---|---|---|
| `group` | Any compact simple gauge group | Partial: G-valued link multiplication, conjugacy-class holonomies and local lattice gauge action; not yet linked to QFT |
| `spacetime` | Noncompact four-dimensional spacetime | Coordinate/test spaces defined; framework adequacy remains, not a missing existence proof |
| `qft-axioms` | Axioms at least as strong as [45,35] | Partial: operator-based Wightman conditions; formal equivalence/adequacy unreviewed |
| `ym-identification` | Same theory is pure Yang–Mills for group G | **Missing:** G-specific four-dimensional lattice data now available, but no proven quantum/continuum identification |
| `gauge-observables` | Local gauge-invariant polynomials in F and covariant derivatives | General actual-G invariant jet-polynomial algebra and equality-on-connections quotient; geometric covariance/presentation equivalence and quantum correspondence open |
| `renormalized-filtration` | Footnote 1's expected dimension-filtered interpretation | **Guidance, not a separate compulsory theorem.** Classical filtration is partially formalized |
| `ultraviolet` | Short-distance asymptotic freedom and renormalization predictions | Actual scaled vacuum correlations and finite testwise remainders defined; fixed YM predictions, RG/mixing and OPE topology missing |
| `stress-tensor` | Prescribed local stress tensor | Partial: same-composite tensor, actual translation charges and anomaly relation; fixed perturbative symbol/beta link unfinished |
| `ope` | Operator product expansion and prescribed local singularities | Partial: actual pair kernels and exhaustive weak remainders; fixed renormalized coefficients and multi-cluster/contact prescription unfinished |
| `nontrivial` | Nontrivial quantum Yang–Mills for G | Non-vacuum states and field excitations defined and derived from the QFT mass condition; Yang–Mills identification and adequacy review remain missing |
| `physical-gap` | Spectrum H≥0, HΩ=0, positive Δ and finite mass m | Concrete spectral statements and generator uniqueness; standard analytic equivalences remain |
| `universal-existence` | Such a theory for **every** compact simple G | Partial: group-quantified QFT-only shadow, proved insufficient by reuse-of-one-theory lemma; YM groupwise target missing |

See [`requirements.json`](requirements.json) for the machine-readable version
of this table. Every clause is currently `partial` or `missing`. No metadata
changes are allowed to certify the full theorem; the Lean proof gate must be
independently reviewed and explicitly enabled once the mathematics is formalized.

## Newly formalized necessary mathematics

- `YangMills/LocalObservables.lean`: concrete finite curvature-jet trace-polynomial
  expressions, engineering dimensions, degree filtration, and a theorem
  identifying quadratic trace components with the classical action density.
  This is **not** yet a proof of gauge invariance or quantum correspondence.
- `YangMills/QuantumCorrelations.lean`: vacuum n-point functions are calculated
  from Wightman field products in the physical Hilbert space, rather than
  supplied as arbitrary data. The actual UV/OPE estimates are still absent.
- `YangMills/GroupwiseNecessary.lean`: exhibits a formally proved loophole.
  A group-indexed QFT-only existence formula follows from a single unlabelled
  massive QFT; it therefore cannot be accepted as Yang--Mills identification.

The evidence above advances the definitions, but **does not** enable Clay
proof admission, does not assume any mass-gap proof and does not settle the
adequacy of the formal QFT axioms.

## Group-specific gauge checks without an identification shortcut

New verified algebraic and finite-regulator constructions:

- `YangMills/GaugeHolonomy.lean`: the actual G-valued link law
  `U_xy ↦ h_x U_xy h_y⁻¹`, ordered holonomies and the conjugacy-invariant
  observable of a closed loop.
- `YangMills/LatticeGaugeAction.lean`: finite central plaquette actions
  and Boltzmann weights with proved local gauge invariance.
- `YangMills/PeriodicLattice4.lean`: a fixed periodic four-dimensional
  lattice, four directions, elementary oriented plaquettes and gauge
  invariance of its finite group-dependent action.

These are nonlocal **finite classical** quantities, not a continuum quantum
Yang–Mills theory. **If a proof chooses this lattice route**, its class
function, measure and convergence steps must be justified and connected to
actual quantum fields/correlations for the same G. An alternative mathematical
construction is equally admissible if it establishes Section 4's requirements.
No particular character, Haar measure, lattice or regulator is prescribed.
A common Hilbert space across gauge groups is allowed if those separate
identifications are proved.

The Lean theorem `qft_exists_implies_unlinked_group_checks` is a negative
control: **one unrelated massive QFT plus all these valid G-dependent
classical gauge checks** still satisfies an inadequate existence statement
when the quantum and classical sectors are not linked. Thus adding a
genuine G-dependent expression next to an unrelated Q is not enough.

Full Clay proof admission remains **blocked**.

## Clarifying non-requirements

§1 describes quark confinement and chiral symmetry breaking in QCD as
motivating physical phenomena, **not** clauses in the pure Yang–Mills
Millennium statement. §5 specifically calls isolated one-particle
states, confinement and extensions to other gauge theories and manifolds
*extensions*. §6 discusses cutoff-to-continuum convergence as a potential
proof strategy, not an additional axiom or an adequate endpoint by itself.

## Certification principle

The paper mixes a mathematically precise core with physical phrases that
require a carefully chosen, independently reviewed formal interpretation
(e.g. renormalized identification, asymptotic-freedom predictions and OPE).
No sound mechanical verifier can infer their intended meaning from the PDF
alone. A completed formalization must supply those meanings *in fixed
definitions*, never as freely selected predicates or axioms in the submission.
Until it exists, `#check_clay_proof` and the source-bound CLI correctly reject
every claimed full certificate.


The detailed updated clause analysis separates missing definitions, missing
supporting equivalence lemmas, and future witness proofs in
[SOURCE_ANALYSIS.md](SOURCE_ANALYSIS.md). The integrated design and outstanding
central work are in [SPECIFICATION_REVIEW.md](SPECIFICATION_REVIEW.md). Missing
existence proofs do not make an otherwise complete definition incomplete.


Current central definitions and exact remaining renormalization work are in
[SPECIFICATION_REVIEW.md](SPECIFICATION_REVIEW.md). The detailed chosen
perturbative flow/BRST prescription and primary equations are in
[PERTURBATIVE_PRESCRIPTION.md](PERTURBATIVE_PRESCRIPTION.md). Bare finite-cutoff
Wick coefficients are implemented; they do not replace renormalized predictions.
