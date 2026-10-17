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
| `group` | Any compact simple gauge group | Partial: `CompactSimpleGaugeGroup`; no final universal theorem |
| `spacetime` | Noncompact four-dimensional spacetime | Partial: spacetime and field types, no existence |
| `qft-axioms` | Axioms at least as strong as [45,35] | Partial: operator-based Wightman conditions; formal equivalence/adequacy unreviewed |
| `ym-identification` | Same theory is pure Yang–Mills for group G | Missing: classical action and QFT not connected |
| `gauge-observables` | Local gauge-invariant polynomials in F and covariant derivatives | Missing correspondence to quantum fields |
| `renormalized-filtration` | Renormalized dimension-filtered operator correspondence | Missing |
| `ultraviolet` | Short-distance asymptotic freedom and renormalization predictions | Missing specified estimates |
| `stress-tensor` | Prescribed local stress tensor | Missing |
| `ope` | Operator product expansion and prescribed local singularities | Missing |
| `nontrivial` | Nontrivial, interacting Yang–Mills, not a free massive field | Missing fixed nontriviality test |
| `physical-gap` | Spectrum H≥0, HΩ=0, positive Δ and finite mass m | Partial: spectral statements defined, existence unproved |
| `universal-existence` | Such a theory for **every** compact simple G | Missing: existing QFT target has no G |

See [`requirements.json`](requirements.json) for the machine-readable version
of this table. Every clause is currently `partial` or `missing`. No metadata
changes are allowed to certify the full theorem; the Lean proof gate must be
independently reviewed and explicitly enabled once the mathematics is formalized.

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
