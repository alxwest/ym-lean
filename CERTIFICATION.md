# Yang--Mills Millennium certification contract

**Status: SPECIFICATION INCOMPLETE (2026-10-20). This repository does not currently define or prove
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
   renormalized correspondence with quantum local fields. Footnote 1 warns
   against a naive one-to-one correspondence and suggests dimension-filtered
   spaces, but **does not make a particular filtered isomorphism a separate
   mandatory theorem**.
3. **Yang--Mills identification.** Give a non-circular mathematical account
   of the pure 4D Yang--Mills quantum theory for G, anchored to its action
   or an equivalent justified construction. A free massive field is not enough.
4. **Ultraviolet predictions.** State the needed short-distance correlations
   and asymptotic-freedom/perturbative-renormalization behavior as concrete
   estimates/limits/identities, including the stress tensor and prescribed
   operator product expansion singularities.
5. **Nontriviality.** Give the PDF's term 'non-trivial quantum Yang--Mills'
   a justified mathematical interpretation. Do not introduce a separate,
   stronger Gaussianity criterion without support in the written statement.
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

## Additional definitions, not an unblocked certificate

The repository now formally defines and kernel-checks a *classical*
curvature-jet trace-polynomial grammar, its engineering-dimension filtration,
vacuum Wightman n-point correlation functions, and a group-quantified
QFT-only necessary theorem. The groupwise theorem has an explicit proof
that **any one** gapped QFT suffices when G is not actually used; this is a
formal counterexample to an inadequate target formulation.

These fragments do not address gauge invariance of the classical expressions
under local transformations, renormalized quantum operator correspondence,
same-theory pure Yang–Mills identification, the prescribed UV/OPE
coefficients, or universal existence *of the identified theory*. The full
Clay checker therefore must continue to return `CLAY_CERTIFICATION_BLOCKED`.

## Executable source-bound admission protocol

The trusted paper is **the repository's own `source/yangmills.pdf`**.
It was checked byte-for-byte against the published PDF. SHA-256:

`3558403ca14c11e382f73a09e548222708540bfdf478cf96aa11c52d43e23e09`

The structured coverage record `source/requirements.json` lists twelve
required clauses from §4 (printed p.6), supporting context from §3, and
requirements that are *not* part of the theorem. `scripts/verify_submission.py`
checks both the paper bytes and the complete clause ID set. Its invariant
is that even if metadata is marked `formalized`, it cannot itself license
a full certification. The Lean gate stays blocked.

The complete `python3 scripts/check_proofs.py` run additionally executes
[`scripts/test_kernel_inspector.py`](scripts/test_kernel_inspector.py),
which compiles adversarial proof modules and verifies that the independent
inspector rejects both type spoofing and `sorryAx` despite an overridden
proof-local audit command.

Run:

```sh
python3 -m unittest discover -s scripts -p 'test_verifier.py' -v
python3 scripts/verify_submission.py --claim clay --report .lake/clay-report.json
python3 scripts/verify_submission.py --claim qft \
  --proof-file MyProof.lean --theorem MyNamespace.myProof \
  --report .lake/qft-report.json
```

The full-Clay claim currently returns exit `2` with
`CLAY_CERTIFICATION_BLOCKED`. An invalid/mismatched source or failed proof
returns `1`. The QFT-only target returns `0` **only** when its Lean proof
kernel-checks with an exact-target transitive-axiom audit; the report still
has `clay_certificate: false`. Proofs are supplied as Lean source, not
unformalized prose. No proof body is bundled or presupposed.

The QFT-only admission path compiles the submitted Lean source separately
to a temporary module, then calls [InspectProof.lean](scripts/InspectProof.lean).
That trusted inspector dynamically imports the checked kernel environment
and rejects non-theorems, wrong target types and all unapproved transitive
axioms. It does not parse user-defined verification commands or trust
submitted diagnostic text. An adversarial regression test explicitly checks
this boundary. The inspector demands a theorem whose raw type is precisely
the named target; authors of definitionally equivalent proof statements
can add an unconditional wrapper theorem with the exact target type.

**Trust model:** The PDF's checksum protects against accidental or unnoticed
source substitution *within this verifier*. The runner, checked-in script,
Lean executable, Mathlib snapshot and fixed specification must still be
trusted/pinned externally (for example by a reviewed Git commit hash).
Someone capable of replacing both the checker and its expected hashes
can defeat an unanchored local run. Lean's kernel checks mathematical
implication from the fixed target; subject-matter review is indispensable
for judging whether the fixed target actually captures the PDF.
## Group-specific lattice mathematics without claiming continuum identification

The repository now defines concrete links in `G.Carrier`, gauge-transform
laws, closed-loop conjugacy classes, finite central actions, Boltzmann
weights and a four-dimensional periodic lattice. Their gauge-invariance
properties have kernel-checked proofs for the **actual multiplication
law of G**.

These are classical/finite and nonlocal. The physical character weight
and measure are not yet fixed, and no rigorous continuum limit has been
related to the actual quantum field operators or Schwinger/Wightman
correlations. The required local gauge-observable renormalization and
UV/OPE behaviour are also still absent.

`qft_exists_implies_unlinked_group_checks` proves an essential negative
case: even a correct G-dependent classical lattice sector can simply
sit alongside one unrelated massive QFT unless an explicit, mathematical
quantum/classical identification is required. A common underlying QFT
or Hilbert carrier is **not** prohibited; group-specific compatibility
must instead be proved for every G.

The full Clay gate remains closed. No arbitrary predicate, user-picked
meaning of Yang–Mills, or new mathematical assumption is introduced.

## Separate literal mathematics from interpretive definitions

The tag PDF_EXPLICIT in YangMills/PDFLiteral.lean denotes a mathematical
fragment visible directly in Section 4: R^4, universal group binder,
positive spectrum, spectral gap, and finite mass. No external
definition or physical construction is asserted to follow merely
from those fragments.

YangMills/SourceClassification.lean provides a checked registry of
declarations split into directMath, citedStandard, interpretedModel
and optionalMethod. The source/requirements.json manifest separately
labels the provenance of all twelve entries; the CLI verifies those
layers have not been silently relabelled. Interpretive terms that do
not yet have rigorous definitions are listed, not postulated.

A mathematical interpretation of the phrase "quantum Yang--Mills for G"
is not itself a new proof assumption. It is a proposed definition of
the problem, requiring fidelity review before a submitted proof can
claim to solve that problem. The proof must still prove every explicit
required property from permitted foundations.

See [source/FORMALIZATION_LAYERS.md](source/FORMALIZATION_LAYERS.md).

## No additional assumptions or preferred proof method

[source/STATEMENT_POLICY.md](source/STATEMENT_POLICY.md) governs the scope:
only Section 4's theorem, its explanatory requirements, and the explicitly
cited mathematical axiom systems can determine pass/fail. Footnote 1's
expected dimension filtration is interpretive guidance, not an additional
axiom or independently compulsory theorem.

No fixed lattice, representation/character, Haar construction, Wilson
plaquette action, particular regulator or continuum-limit method is required
of every proof. Distinct Hilbert spaces for distinct groups, confinement,
isolated one-particle states and arbitrary Gaussianity tests are not additional
universal conditions. If a proof uses such machinery, all necessary steps
must of course be justified within that proof.

Defining a missing required mathematical condition must not assume its truth.
A formalization should be judged for fidelity to the PDF and cited axiom
systems before its proof checker can claim certification. That independent
review is a validation step, **not another hypothesis of the theorem**.

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

- `YangMills/Nontriviality.lean` defines non-vacuum states and field-word
  excitations for the same QFT. It proves their equivalence under cyclicity
  and derives both from `GappedWightmanTheory`, using the actual Hamiltonian
  resolvent. This excludes a vacuum-only theory without an added assumption,
  but does not identify it as Yang–Mills or resolve the full nontriviality clause.

- `YangMills/Statement.lean` defines only a gauge-independent QFT-and-gap
  existential proposition.
- `YangMills/GaugeGroup.lean` and `YangMills/Classical.lean` supply classical
  vocabulary but do **not** connect it to that proposition.
- `YangMills/Verification.lean` audits definitions and helper lemmas. It
  deliberately contains **no existence proof**.

**Next specification milestone:** give a complete, reviewable mathematical
definition of the quantum Yang--Mills identification and UV correspondences
before attempting to add an exact Clay proof-admission command.


## Specification work of 20 October 2026

The specification task is still **incomplete**, independently of the absence
of any existence proof. New central fragments cover arbitrary group-invariant
curvature-jet polynomials and their equality-on-connections quotient, normalized
Schwartz dilation of actual field correlations, finite remainder estimates and
a checked arbitrary-coefficient negative control. New supporting lemmas prove
smeared-field closability, physical-Hamiltonian uniqueness, and properties of
the supremum mass. These additions are transitively audited in the default build.

The exact unresolved meanings, attempted approaches, source crosswalk and
independent adversarial review are in [source/SPECIFICATION_REVIEW.md](source/SPECIFICATION_REVIEW.md).
Missing fixed perturbative Yang–Mills coefficients and their same-theory
renormalized/UV/OPE/stress-tensor relations prevent introducing a full target.
Geometric gauge covariance and exact cited-standard equivalences also remain.
A passing build does not resolve these findings.

Use `python3 scripts/verify_submission.py --claim specification` to assess
readiness without a proof file. The JSON report separates specification
readiness, proof submission, kernel checking, semantic review and external
acceptance. No missing existence proof is a specification blocker. Exact full
proof admission remains closed because the required definitions and fidelity
argument are incomplete; QFT-only admission still concerns its named necessary
formal target only.


## Central continuation: actual fields, stress and OPE/RG relations

The current specification includes same-domain renormalized composite maps,
derivative and Poincare identities, composite-only cyclicity, intrinsic-degree
mixing, stress-tensor charges to the actual physical Hamiltonian, coherent weak
OPE truncations and all-order running-coupling matching. Tensor Wick rotation
and one common running system across all finite sectors are explicit. The
perturbative anchor fixes actual-G vertices, all-order **bare finite-cutoff**
Wick coefficients and classical observable insertions.

These advances do not complete the target. The formal prediction parameters
in `RG.CoupledSectorConditions` must be replaced by outputs of a fully specified
renormalized construction with the quantum gauge identities, normalization,
UV/switching limits and OPE extraction. No proof of this parameterized relation
is admitted as full YM. The old action's factor-two normalization difference
is exposed by a checked bridge, not silently equated to the new convention.
See the rewritten [integrated review](source/SPECIFICATION_REVIEW.md) and
[central adversarial review](source/CENTRAL_ADVERSARIAL_REVIEW.md).
