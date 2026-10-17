# Yang--Mills Millennium certification contract

**Status: BLOCKED (2026-10-17). This repository does not currently define or prove
the full Clay/Jaffe--Witten problem. A green `lake build`, successful axiom
audit, or even a future proof of `QFTExistenceAndMassGap` is not a Clay
certificate.**

Official technical statement, Jaffe--Witten, section 4:
https://www.claymath.org/wp-content/uploads/2022/06/yangmills.pdf

## What a full formal target must mean

For **every compact simple Lie gauge group G**, construct **a nontrivial
four-dimensional quantum Yang--Mills theory for that G**, with local quantum
fields and spectral dynamics meeting QFT axioms at least as strong as the
Wightman/Osterwalder--Schrader axioms, and prove that its physical Hamiltonian
has a strictly positive **finite** mass gap.

In addition to the existing `QFTExistenceAndMassGap` obligations, a future
closed (no theorem/predicate parameters) Lean statement needs **specific**
mathematical definitions and proven facts for all of:

1. **Gauge-group quantification and same-object link.** Quantify over the
   concrete `CompactSimpleGaugeGroup`; identify the *same* group with the
   quantum field theory, rather than merely appending an unused group index.
2. **Local gauge-invariant observables.** Specify genuine gauge-invariant
   differential polynomials in curvature and covariant derivatives and their
   renormalized correspondence with quantum local fields. Include the
   dimension-filtered operator-mixing/renormalization subtleties.
3. **Yang--Mills identification.** Give a non-circular mathematical account
   of the pure 4D Yang--Mills quantum theory for G, anchored to its action
   or an equivalent justified construction. A free massive field is not enough.
4. **Ultraviolet predictions.** State the needed short-distance correlations
   and asymptotic-freedom/perturbative-renormalization behavior as concrete
   estimates/limits/identities, including the stress tensor and prescribed
   operator product expansion singularities.
5. **Nontriviality.** Exclude Gaussian/free/trivial substitutes in a way
   appropriate to the identified pure Yang--Mills theory.
6. **Complete QFT and physical gap.** Prove the required axioms and show the
   gap belongs to the *time-translation Hamiltonian of that same theory*,
   with a positive finite spectral mass. A finite-volume/lattice gap alone
   is insufficient without justified same-object continuum/OS transfer.
7. **Independent semantic review.** The mathematical definitions and the
   claimed equivalence to the Jaffe--Witten statement require expert
   external review. No kernel can decide their physical fidelity by itself.

Do **not** satisfy any item by inventing an uninterpreted proposition,
postulating an axiom, omitting the difficult terms, attaching an unused
`G`, or assuming the desired conclusion.

## Machine-checking protocol

- `lake update && lake exe cache get && lake build` checks the present library.
- `python3 scripts/check_proofs.py` regression-tests the QFT-only checker and
  that `#check_clay_proof` rejects unrelated, assumed and group-agnostic proofs.
- `#clay_certification_status` explicitly prints `CLAY_CERTIFICATION_BLOCKED`.
- `#check_qft_proof TheoremName` checks an exact, unconditional
  `YangMills.QFTExistenceAndMassGap` proof and allows only the standard Lean
  foundational axioms. This is **not** Clay certification.
- `#check_clay_proof TheoremName` **always fails today**. There is no complete
  full-problem target to check. The gate must only be unlocked after the
  definitions above are implemented and independently reviewed. At that
  point it must enforce exact full-target type and transitive axiom checks
  at least as strict as `#check_qft_proof`.

Successful kernel checking would authenticate a formal proof relative to
those fixed definitions and Lean's trusted kernel/mathlib. It would not
by itself constitute Clay Mathematics Institute's independent acceptance.

## Current evidence

- `YangMills/Statement.lean` defines only a gauge-independent QFT-and-gap
  existential proposition.
- `YangMills/GaugeGroup.lean` and `YangMills/Classical.lean` supply classical
  vocabulary but do **not** connect it to that proposition.
- `YangMills/Verification.lean` audits definitions and helper lemmas. It
  deliberately contains **no existence proof**.

**Next scientific milestone:** give a complete, reviewable mathematical
definition of the quantum Yang--Mills identification and UV correspondences
before attempting to add an exact Clay proof-admission command.
