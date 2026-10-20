# Literal-statement verification policy

**Normative document:** [`yangmills.pdf`](yangmills.pdf), Jaffe–Witten, Section 4 (printed page 6). The source PDF has a pinned SHA-256 digest enforced by the CLI.

## What may be a pass/fail condition

A full certificate may demand only mathematical consequences of the written theorem, its Section 4 explanation, and the axiom systems explicitly referenced in the paper. In particular:

- The Section 4 theorem asks for a nontrivial quantum Yang–Mills theory on four-dimensional R^4 for every compact simple gauge group G, with a positive mass gap and axioms at least as strong as the cited standards.
- The accompanying Section 4 text specifies correspondence of local quantum fields to gauge-invariant local curvature polynomials and their covariant derivatives; short-distance agreement with asymptotic freedom and perturbative renormalization, including stress tensor and operator product expansion; and a finite mass defined using the Hamiltonian's spectral gap.
- Section 4 footnote 1 **rejects naive one-to-one matching** of classical polynomials and quantum operators. It **expects** a relationship between spaces filtered by dimension. This expectation informs interpretation, but the particular exact filtered isomorphism is **not** a standalone mandatory theorem.
- External references [45,35] provide mathematical meanings for the cited axiomatic standards. A candidate formalization must identify any other external definitions it relies on, and justify fidelity to the written conditions.

## What cannot be added as an assumption or required proof strategy

- No specific four-dimensional lattice, Wilson character, central plaquette function, Haar product measure, regulator, or continuum-limit technique is imposed as a universal obligation.
- No requirement for different Hilbert spaces for distinct G; the same carrier may be reused if it meets the actual requirements for each G.
- No independent requirement for confinement, an isolated one-particle state, or chiral-symmetry breaking (the statement treats related topics as motivations/extensions).
- No arbitrary non-Gaussian criterion, extra numerical bounds, coefficients not justified by the cited perturbative predictions, or unreferenced physical conditions may be added as admission conditions.
- No missing condition may be assumed true, replaced by a free predicate, supplied by the proof author's choice of meanings, or omitted as inconvenient.

Formalizing a required condition is **not** an assumption that the condition holds. The proof must establish it. The mathematical definition must be fixed and reviewed before acceptance.

## Explicit Lean versus interpretation: a second provenance axis

[FORMALIZATION_LAYERS.md](FORMALIZATION_LAYERS.md) and
[YangMills/PDFLiteral.lean](../YangMills/PDFLiteral.lean) distinguish
the formulae directly transcribed from Section 4 from mathematical
frameworks cited by Section 4, interpretive definitions for its
physically meaningful terms, and optional proof constructions.

An "interpretation needed" label does **not** mean a new assumption
is authorised; it means the full mathematical definition is still
missing or needs independent fidelity review. An explicit requirement
may legitimately be marked "interpretation needed", because the prose
does not uniquely supply its entire formal meaning.

The verifier pins formalization_layer as well as acceptance_role,
and reports both. Neither provenance labels nor text coverage can
unlock the full Clay checker.

## Traceability contract

`requirements.json` distinguishes `required` Section 4 clauses from `interpretive_guidance` in footnote 1. The verifier fixes each clause's source basis in its own code, so tampering with the manifest cannot silently turn a suggested method into a strict certification requirement. A complete coverage label never automatically unlocks the Clay checker.

New formal lemmas about group-valued links, plaquette gauge invariance, or Wilson holonomy are legitimate **optional infrastructure**, not conditions every valid solution must use. The group-specific identification in the theorem is required because it says **Yang–Mills for G**; this does not imply a particular construction or presentation.

Any proposed full Lean statement must come with a reviewable equivalence/sufficiency argument relative to the PDF and cited frameworks. The kernel certifies derivations from that Lean statement; it cannot independently decide whether a chosen formalization faithfully represents physics.

**Current status:** `CLAY_CERTIFICATION_BLOCKED`. No complete faithful mathematical statement or proof is yet certified.


## Specification readiness is independent of proof submission

Missing definitions and missing supporting equivalence/fidelity arguments block
specification readiness. Absence of an existence proof does not. The executable
`--claim specification` assessment returns `SPECIFICATION_INCOMPLETE` for the
current missing meanings even when no proof file is supplied. Kernel verification
of a submitted theorem, semantic review of its fixed target, and external/CMI
acceptance are separate report fields. See `SPECIFICATION_REVIEW.md`.
