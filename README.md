# Yang–Mills: a fixed Lean specification

This repository defines a complete, reviewed **proposed formal specification**
of the Jaffe–Witten existence and mass-gap problem. It does **not** contain an
existence proof. External mathematical acceptance has not been assessed.

The closed target is `YangMills.YangMillsExistenceAndMassGap.{u}` in
[YangMillsSpecification.lean](YangMills/YangMillsSpecification.lean):

```lean
def YangMillsExistenceAndMassGap : Prop :=
  ∀ G : CompactSimpleGaugeGroup.{u}, Nonempty (FilteredGeneratedCandidate G)
```

For each actual compact connected simple Lie gauge group, the candidate binds
one physical QFT, its complete Wightman hierarchy and physical Hamiltonian to
the same group-specific action, renormalization flow, corrected observables,
all-order UV/OPE predictions, local contact terms and stress tensor. A future
proof supplies witnesses satisfying these concrete definitions; it cannot
choose substitute predicates for Yang–Mills or the prescribed predictions.

The physical Hilbert space is positive, the common field domain is dense and
invariant, and the Hamiltonian is the full self-adjoint time generator. Its
spectral mass must be positive and finite; no isolated particle or confinement
condition is added. The composite correspondence respects classical identities
and descendants and generates the same physical space, while allowing quantum
relations and operator mixing.

The auxiliary Gaussian flow fixes perturbative predictions, not a required
nonperturbative construction method. Its original canonical insertion rows
now determine the actual smooth responses by proof. The literal finite
Fourier/Taylor density, its normalization jets and the same-field stress
transport have checked meanings. All-order asymptotics use finite remainders
as the running coupling tends to zero; they do not assert convergence of a
formal series. Smooth completions and nonperturbative flat terms are allowed.
The physical stress dictionary has degree four; its BRST response has the
distinct degree-five bound. Both sides of the trace anomaly use the same
actual vacuum centering, with the identity term computed from their onepoints.

## Review and provenance

- [Final fidelity argument](source/FINAL_FIDELITY_ARGUMENT.md)
- [Clause-by-clause source crosswalk](source/CURRENT_JW4_READINESS_CROSSWALK.md)
- [Final adversarial review](source/FINAL_ADVERSARIAL_REVIEW.md)
- [Statement policy](source/STATEMENT_POLICY.md) and
  [certification contract](CERTIFICATION.md)
- [Source registry](source/requirements.json) and
  [provenance classifications](source/FORMALIZATION_LAYERS.md)

These explain the presentation choices, the exact source comparisons and
limitations of the review. The full cited [45] book chapter was not directly
accessed; the comparison uses the primary coauthor exposition and the OS
sources, with that access qualification recorded. A checked build or an agent
review is not a proof of equivalence to prose or evidence of CMI acceptance.
Earlier review files record historical findings; current readiness is governed
by the documents above, not superseded gap paragraphs.

## Checks and future proof admission

The pinned Lean/mathlib environment is recorded in `lean-toolchain` and
`lake-manifest.json`.

```sh
lake build
python3 scripts/check_proofs.py
python3 scripts/verify_submission.py --claim specification
```

The last command checks the compiled exact target shape and reports
`SPECIFICATION_READY`; it does not verify an existence proof. With no proof,
`--claim yangmills` instead reports `PROOF_NOT_SUBMITTED`.

A future submission uses:

```sh
python3 scripts/verify_submission.py --claim yangmills --proof-file proof.lean --theorem MyProof.solution
```

The submitted declaration must be an unconditional theorem of the exact
universe-polymorphic target, with one universe parameter. A separate process
inspects the compiled checked environment and transitive axioms. Only the
standard Lean foundations `propext`, `Classical.choice` and `Quot.sound` are
allowed. A fixed-universe, conditional, assumed, wrong-type or sorry-based
claim is rejected. The QFT-only mode remains separately available.

Kernel acceptance, source interpretation and external acceptance are distinct.
The verifier always reports `clay_certificate=false`, including after a future
exact-target kernel proof. The legacy `--claim clay` spelling is only an alias
for mathematical proof checking.
