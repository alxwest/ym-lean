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
The expected relationship is between the *filtered spaces of operators of
dimension at most d*. That subtlety is a proof obligation, not a waiver.

## Complete clause inventory

| ID | From the PDF | Implemented in Lean? |
|---|---|---|
| `group` | Any compact simple gauge group | Partial: G-valued link multiplication, conjugacy-class holonomies and local lattice gauge action; not yet linked to QFT |
| `spacetime` | Noncompact four-dimensional spacetime | Partial: spacetime and field types, no existence |
| `qft-axioms` | Axioms at least as strong as [45,35] | Partial: operator-based Wightman conditions; formal equivalence/adequacy unreviewed |
| `ym-identification` | Same theory is pure Yang–Mills for group G | **Missing:** G-specific four-dimensional lattice data now available, but no proven quantum/continuum identification |
| `gauge-observables` | Local gauge-invariant polynomials in F and covariant derivatives | Partial: curvature jets plus **nonlocal** G-valued Wilson holonomy conjugacy classes with lattice gauge-invariance proofs; local quantum correspondence open |
| `renormalized-filtration` | Renormalized dimension-filtered operator correspondence | Partial: classical engineering-degree filtration; filtered quantum operator identification still missing |
| `ultraviolet` | Short-distance asymptotic freedom and renormalization predictions | Partial: genuine vacuum n-point functions defined; UV asymptotics and perturbative limits missing |
| `stress-tensor` | Prescribed local stress tensor | Missing |
| `ope` | Operator product expansion and prescribed local singularities | Missing |
| `nontrivial` | Nontrivial, interacting Yang–Mills, not a free massive field | Missing fixed nontriviality test |
| `physical-gap` | Spectrum H≥0, HΩ=0, positive Δ and finite mass m | Partial: spectral statements defined, existence unproved |
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
Yang–Mills theory. To establish identification, a proof must relate the
actual quantum fields/correlations to a justified, fixed construction
for the *same* G, including the appropriate character, Haar measure,
renormalized continuum limit and the required local observable/UV behaviour.
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
