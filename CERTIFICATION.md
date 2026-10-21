# Formal specification and proof-admission contract

**Specification:** complete reviewed proposal, with a fixed all-group Lean
proposition. **Existence proof:** not supplied. **External acceptance:** not
assessed. These are independent states.

The normative source is Jaffe–Witten, *Quantum Yang–Mills Theory*, §4, printed
p.6, with the action/QFT context and the mathematical frameworks it cites.
The exact PDF is pinned by its SHA-256 in `source/requirements.json`.
The complete clause crosswalk, interpretive choices, source access
qualifications and resolved adversarial findings are recorded in
`source/FINAL_FIDELITY_ARGUMENT.md`, `CURRENT_JW4_READINESS_CROSSWALK.md`
and `FINAL_ADVERSARIAL_REVIEW.md`.

## Fixed mathematical target

`YangMills.YangMillsExistenceAndMassGap.{u}` universally quantifies the actual
compact connected simple Lie gauge groups in universe u and requires
`Nonempty (FilteredGeneratedCandidate G)` for each. All fields and properties
of that candidate are fixed concrete definitions. There is no theorem
parameter, freely selected Yang–Mills predicate, axiom, or existence proof in
the definition.

The same candidate contains the actual group/action and auxiliary perturbative
prescription, complete physical QFT, renormalized observable correspondence,
full generated Ward/CS and physical UV/OPE matching, stress tensor and actual
translation Hamiltonian with positive finite spectral mass. It does not demand
confinement, an isolated mass eigenstate, a particular nonperturbative
construction, a classical/quantum bijection, a convergent perturbative germ,
or uniqueness of exact beta completions.

## What the checker establishes

`--claim specification` needs no existence proof. After trusted review
activation, source validation, a successful build and inspection of the
compiled exact all-group target, it reports `SPECIFICATION_READY`.

`--claim yangmills` without a submission reports `PROOF_NOT_SUBMITTED`.
A submitted proof must compile and be a checked theorem of the exact target
with one universe parameter. The independently run kernel-environment
inspector rejects extra hypotheses, a fixed universe, a different target,
non-theorem declarations and unapproved transitive axioms. The only allowed
axioms are Lean's standard propext, Classical.choice and Quot.sound.
An equivalent statement can be wrapped in an unconditional theorem of the
exact target before submission.

`--claim qft` checks only the separate QFT-only proposition. It cannot certify
the group-specific Yang–Mills specification. The legacy `clay` command spelling
does not change the meaning or status of a kernel check.

Coverage metadata alone cannot enable admission. The trusted implementation
has explicit review activation, and the inspector checks the actual compiled
definition rather than a declaration name or editable status label. Reports
include source/model/verifier fingerprints and keep specification readiness,
proof submission, kernel verification, semantic review and external acceptance
separate.

## What no local check establishes

A Lean kernel proof is a proof relative to the chosen fixed formal statement.
It does not mechanically establish the fidelity of that statement to the
source prose or mathematical community acceptance. The documented source
comparison is a reviewed sufficiency interpretation, not a uniqueness claim
about formalization. The [45] full-chapter access qualification remains
explicit. No external expert endorsement or CMI decision is asserted.
`clay_certificate` therefore remains false even for a future accepted exact
kernel theorem. This checkout contains no such existence theorem.
