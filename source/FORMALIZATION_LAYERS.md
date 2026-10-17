# Lean provenance for the Jaffe–Witten statement

The normative document is the exact pinned `source/yangmills.pdf`, Section 4,
printed page 6 (and the axiom systems it explicitly cites).

**Two independent classifications apply to each paper clause:**

- **Acceptance role**: `required` or `interpretive_guidance`. The former is
  something a genuine proof must establish; the latter is not an extra test.
- **Formalization layer**: how directly the mathematical meaning can be
  translated into fixed Lean. A requirement can be explicitly written in
  the paper *and still need interpretation* before a faithful theorem exists.

## DIRECT — literal mathematical content

Source: Section 4, page 6. Implemented and marked `PDF_EXPLICIT` in
[`YangMills/PDFLiteral.lean`](../YangMills/PDFLiteral.lean).

| Written content | Lean declaration | Important limitation |
| --- | --- | --- |
| Four-dimensional R^4 | `PDFLiteral.FourDimensionalSpace` | A coordinate space, not existence of a QFT |
| Exact equation HΩ = 0 | `PDFLiteral.HamiltonianKillsVacuum` | Written using the selected unbounded-operator domain; does not supply H or Ω |
| Positive energy and zero vacuum energy | `PDFLiteral.HamiltonianSpectralFacts` | Zero in spectrum does not replace proving HΩ = 0 |
| Positive spectral interval (0, Δ) is empty | `PDFLiteral.PositiveGap` | A property of a given spectrum, not an existing Yang–Mills Hamiltonian |
| Mass is supremum of admissible gaps, finite | `PDFLiteral.PositiveFiniteMass` | Finite nonempty bounded set of gaps, still no theory exists |
| For every compact simple G | `PDFLiteral.ForEveryCompactSimpleGroup` | **Only the universal quantifier**; its predicate may not be chosen by proof author |

These are all checked by Lean and receive transitive axiom audits in
`YangMills/Verification.lean`. None is named a Clay-existence theorem.

## REFERENCED — definitions delegated to other mathematics

- `CompactSimpleGaugeGroup`: the formal Lie-group encoding of the words
  'compact simple gauge group'. Choices such as connectedness and
  smoothness need justification from the paper and mathematical conventions.
- `WightmanAxioms`: an operator-based encoding of an axiom system the
  paper cites. Faithfulness to references [45,35] is a separate review task.

These are tagged `citedStandard` in
[`YangMills/SourceClassification.lean`](../YangMills/SourceClassification.lean).

## INTERPRETATION NEEDED — explicit requirements, unfinished meaning

The written paper **requires** quantum Yang–Mills existence, nontriviality,
local gauge-invariant quantum observables and correspondence, short-distance
agreement with asymptotic freedom/perturbation theory, stress tensor and OPE.
But it does not spell out a unique entire Lean implementation of those
terms. Proposed definitions are tagged `interpretedModel`, with their
source and precise scope recorded. Missing definitions are kept as text
in `interpretationStillNeeded` — **not** invented `Prop` placeholders or
assumed axioms.

`QuantumTheory`, `CurvatureScalarPolynomial.evaluate` and
`WightmanData.vacuumNPoint` are useful interpreted models of parts of the
written language, but none is itself the demanded nontrivial quantum
Yang–Mills theory for G.

## OPTIONAL — proof constructions, not acceptance conditions

`wilsonConjugacyClass_gauge_invariant`, `periodicFourClassAction`,
and `qft_exists_implies_unlinked_group_checks` are tagged
`optionalMethod`. They can help a particular proof or falsify a bad
formalization, but lattice holonomies, Wilson-type actions or a chosen
regulator are **not required** of every proof.

## How the classification is enforced

- `source/requirements.json` uses `formalization_layer` for all 12 tracked
  clauses and the separate `acceptance_role` for their status in the PDF.
- `scripts/verify_submission.py` pins the allowed classification of each
  clause; tampering with it fails source validation.
- `YangMills/SourceClassification.lean` records declaration-level origins.
- The default `lake build` runs `#audit_pdf_origins` and the kernel
  dependency checks. The audit checks that the named declarations exist,
  **not** that a human provenance label is semantically correct.
- The full Clay checker remains fail-closed until all interpretations
  are formalized and independently reviewed against the PDF and references.

**No interpretation is an assumption of truth.** It is a proposed
mathematical definition that future proof authors must actually satisfy.
Human mathematical review is unavoidable for equivalence to the prose;
Lean certifies derivations relative to the fixed formal statements.
