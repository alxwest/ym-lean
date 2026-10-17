# Yang–Mills: concrete Lean proof obligations

**Status: substantially expanded, but not yet a complete formalization of the
Jaffe–Witten problem.** The QFT axioms, unbounded Hamiltonian, mass-gap condition,
gauge groups, and classical action now have concrete definitions. The quantum
Yang–Mills identification and prescribed ultraviolet behavior remain unfinished.
A kernel-checked proof of the current target is not a proof of the Millennium
problem.

**Certification safety:** see [CERTIFICATION.md](CERTIFICATION.md). The
`#clay_certification_status` command reports `CLAY_CERTIFICATION_BLOCKED` on
ordinary builds. `#check_clay_proof` rejects all candidates until an independently
reviewed full statement is encoded; this is intentional, not a Lean limitation.

The old `Framework` and `YangMillsExistenceAndMassGap` declarations have been
removed: they let the prover choose the meaning of the central requirements,
including setting them to `True`. There are no replacement predicate parameters
for the missing requirements. No full Yang–Mills submission target is exported
until those requirements are defined.

## Source-anchored proof verification

The **exact bytes** of the locally committed [`source/yangmills.pdf`](source/yangmills.pdf)
(Jaffe–Witten, section 4, printed page 6) are pinned by SHA-256.
[`source/requirements.json`](source/requirements.json) maps every principal clause
to Lean declarations and explicitly records **partial or missing** formalization.
The source-anchored verifier checks the PDF and rejects altered or incomplete
clause inventories; a status label cannot unlock a Clay certificate.

```sh
# Paper-level submission: returns exit 2 / CLAY_CERTIFICATION_BLOCKED until
# a full, independently reviewed specification exists.
python3 scripts/verify_submission.py --claim clay --report .lake/clay-report.json

# A submitted *QFT-only* Lean proof can be checked against the existing
# precise theorem; this is NOT Clay certification.
python3 scripts/verify_submission.py --claim qft \
  --proof-file MyProof.lean --theorem MyNamespace.myProof \
  --report .lake/qft-report.json

# Source-identity, omission and malicious-proof regression tests (fast):
python3 -m unittest discover -s scripts -p 'test_verifier.py' -v
```

The QFT-only CLI **does not trust audit commands or success messages from
the submitted source**. It first compiles the candidate into a Lean module;
an independent [kernel inspector](scripts/InspectProof.lean) then imports
the checked environment, requires the *exact* target theorem type, and
traverses its axioms. This prevents proof-local command shadowing from
counterfeiting acceptance. Use the CLI rather than a source-authored
audit message when verifying someone else's proof.

Exit codes from the new CLI: `0` = genuine acceptance of the **QFT-only**
exact target; `1` = failed verification or invalid source; `2` = blocked
full Clay certification. The JSON report always has `clay_certificate: false`
until the complete target has been specified and the Lean checker has been
audited and deliberately unlocked. See [CERTIFICATION.md](CERTIFICATION.md)
for the trust model and [source/REQUIREMENTS.md](source/REQUIREMENTS.md) for
the precise clause-by-clause paper crosswalk.

**Scope note:** The paper does *not* require a one-to-one identification of
classical polynomials with renormalized quantum operators (footnote 1).
It likewise distinguishes requirements from extensions such as an isolated
one-particle state or quark confinement. The verifier reflects these
distinctions rather than adding arbitrary extra conditions.
## Read alongside Jaffe–Witten

See the supplied [reference PDF](source/yangmills.pdf) or the
[official description](https://www.claymath.org/wp-content/uploads/2022/06/yangmills.pdf).

| Paper | Lean file | What is defined |
| --- | --- | --- |
| §1: gauge group | [GaugeGroup.lean](YangMills/GaugeGroup.lean) | Compact connected finite-dimensional smooth real Lie group, simple tangent Lie algebra |
| §1: classical theory | [Classical.lean](YangMills/Classical.lean) | Smooth connection, curvature, covariant derivative, invariant quadratic form, finite Euclidean action |
| §3: spacetime and symmetries | [Spacetime.lean](YangMills/QFT/Spacetime.lean) | Minkowski metric, forward cone, proper orthochronous transformations, spacelike supports |
| §3: quantum fields | [Wightman.lean](YangMills/QFT/Wightman.lean) | Explicit bosonic field axioms on one invariant domain |
| §§3–4: Hamiltonian | [Operator.lean](YangMills/QFT/Operator.lean) | Dense operator domain, adjoint graph, bounded two-sided resolvent, actual spectrum |
| §4: positive finite mass | [Spectrum.lean](YangMills/Spectrum.lean) | Spectral gap, bounded set of admissible gaps, supremum mass, supporting theorems |
| Current necessary target | [Statement.lean](YangMills/Statement.lean) | `QFTExistenceAndMassGap`, **not** full Yang–Mills existence |
| Proof admission | [Audit.lean](YangMills/Audit.lean) | Exact-target and transitive axiom checks |
| Default-build audit | [Verification.lean](YangMills/Verification.lean) | Audits the current specification and all supporting lemmas |

## What a QFT proof must establish

`WightmanData` supplies the mathematical objects. `WightmanAxioms` contains
fixed propositions about them, each requiring a proof:

- Completeness and separability of the complex Hilbert space; a common dense
  domain preserved by all smeared fields and symmetry transformations.
- A strongly continuous unitary representation of the proper orthochronous
  Poincaré transformations, with explicit identity and composition laws.
- A normalized invariant vacuum, unique among translation-invariant vectors
  up to a complex scalar.
- The joint energy–momentum spectral condition, expressed by Fourier tests
  outside the closed forward cone, with explicit integrability obligations.
- Continuous linear dependence of smeared fields on Schwartz test functions,
  and the adjoint relation on the invariant domain.
- Covariance of finite-component field multiplets, with continuous component
  representations and the actual spacetime pullback of test functions.
- Local commutativity for spacelike-separated test-function supports.
- Vacuum cyclicity under finite products of smeared fields.
- Self-adjointness of the Hamiltonian, including its adjoint domain; equality
  of its domain and action with those of the time-translation generator.
- Real, nonnegative Hamiltonian spectrum and a zero-energy vacuum.

The operator formulation here uses countably many finite-component bosonic
multiplets. It is not a formal equivalence theorem with every published
Wightman or Osterwalder–Schrader formulation. The Euclidean reconstruction
route has not been implemented.

`GappedWightmanTheory` adds a strictly positive gap and a finite supremum of
admissible gaps. Its spectrum is derived from the actual Hamiltonian's
resolvent; it cannot be supplied as an arbitrary set. The code proves that
an eigenvalue lies in this spectrum, that the vacuum therefore has spectral
energy zero, and that a vacuum-only spectrum fails the finite-mass condition.
Continuous spectrum is included; no isolated particle eigenvalue is required.

## Check a proof

With `elan` installed:

```sh
lake update
lake exe cache get
lake build
python3 scripts/check_proofs.py
```

The regression runner checks both acceptance of legitimate lemmas and rejection
of direct/hidden `sorry`, custom axioms, an assumed target, the wrong target,
and conclusions requiring additional hypotheses. Negative fixtures are generated
under `.lake`, not imported into the library.

The library build treats warnings as errors and disables implicit declaration
of unbound names. Its `Verification` module audits the current definitions and
lemmas for extra axioms. Future submitted proofs must still use the submission
command below; adding a theorem somewhere does not automatically audit it.

To audit a theorem's dependencies in a Lean file:

```lean
import YangMills

#audit_axioms YangMills.WightmanAxioms.vacuum_mem_spectrum
```

For an actual submitted proof of the current QFT-only existence target, add
`#check_qft_proof YourTheoremName` after its declaration, then run
`lake env lean YourFile.lean`. This command requires **exactly** the closed
`YangMills.QFTExistenceAndMassGap` type. A theorem assuming the target or `False`
is rejected even if it contains no extra axioms.

`#check_clay_proof SomeTheorem` currently **always fails**, even if the theorem
has no sorry or extra axioms. That is the correct result while no faithful full
Clay statement has been encoded. `#clay_certification_status` reports why.

Both audit commands inspect transitive dependencies, including dependencies
in declaration types. Only the usual Lean foundations `propext`,
`Classical.choice`, and `Quot.sound` are allowed. `sorryAx`, project-specific
axioms, and additional native-evaluation trust axioms are rejected. An axiom
audit alone does not check which proposition was proved; use the exact-target
command for a submission. Ordinary `lake build` alone also does not establish
absence of proof holes in future submissions.

These checks trust the installed Lean kernel, the pinned mathlib dependency,
and the unchanged specification/audit code. They cannot establish that a
mathematical definition faithfully captures the physics merely by typechecking
it, or defend against someone modifying the target or the checker itself.

## What must be completed before accepting a Yang–Mills proof

The following are missing mathematical specifications, not assumptions accepted
by the checker:

1. A renormalized correspondence between local quantum observables and
   gauge-invariant differential polynomials in the curvature, respecting
   dimension filtrations and operator mixing.
2. A precise quantum identification with **pure Yang–Mills for the specified
   group**. Merely having the classical curvature/action in a separate file
   does not supply this link.
3. The required short-distance asymptotics and perturbative renormalization
   predictions, including a stress tensor and operator product expansion with
   specified singularities, formulated as actual limits, estimates, and identities.
4. A justified non-triviality condition for that identified theory, and the
   final quantifier over all the concrete compact simple gauge groups.
5. A mathematical review of the resulting specification against the cited
   axiomatic frameworks and Jaffe–Witten's full requirements.

Until these are implemented, a massive free field could pass the QFT-only
target. The checker explicitly labels its result accordingly. Naming a free
predicate “Yang–Mills” or requiring a proof of an arbitrary proposition would
not resolve these missing steps.
