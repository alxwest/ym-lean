# Final verification record

The pinned Lean 4.25.0/mathlib environment strictly compiles the central
same-action bridges: canonical high-UV adequacy, literal Fourier/Taylor
recovery, integrated versus computed pointwise normalization, marginal and
Ward normalization, single/multiple insertion uniqueness, scalar OPE
extraction and ultraviolet limit uniqueness, and same-field stress transport.

Earlier integrated full runs passed the C∞ corrections, canonical smooth
insertion determinacy and centered stress trace changes (3163 build jobs,
21 runner regressions, 15 proof-audit cases and the then-current inspector
checks). These are supporting lemmas and specification checks, not an
existence proof.

The final activated combined suite passed in the isolated staging copy:
34 runner regressions, the default strict build (3182 jobs), 15 proof-audit
cases, the compiled literal all-group definition-shape check and all 12
real kernel rejection cases. Actual-repository verification follows guarded
integration and is recorded below before completion.
Initial audit-list namespace typos were corrected before the final run.

Independent source and adversarial re-reviews of the final staged assembly
identified no concrete remaining mathematical blocker. They checked the
same G/action/normalization/C/fields/words/OPE/stress/translation links,
degree-four stress versus degree-five BRST response, and C∞ smoothness.
The source crosswalk records the framework-access qualifications.

No Yang–Mills existence theorem is supplied. Kernel verification of a future
existence submission has not run. External acceptance is not assessed and
no Clay certificate is claimed.

## Actual-repository results

The guarded integration copied 40 reviewed files. Before the final
record/crosswalk wording update, all 40 were byte-identical to their tested
staging versions. The actual-repository default strict build passed (3182
jobs), including all new central bridge axiom audits. The 34 runner tests
and all 15 proof-audit cases passed.

The public actual-repository reports returned:

- `--claim specification`: `SPECIFICATION_READY`, readiness `ready`,
  source PDF hash verified, exact target shape `passed`, no incomplete
  coverage clauses, and the fixed all-group target defined.
- `--claim yangmills` without a submission: `PROOF_NOT_SUBMITTED`
  (expected exit 2), while specification readiness remains `ready`.
- Both modes: proof `not_submitted`, existence-kernel verification
  `not_run`, external acceptance `not_assessed`, and `clay_certificate=false`.

The independent compiled kernel suite passed the literal actual all-group
definition-shape check and rejected all 12 malformed submissions. The whole
actual-repository verification command exited 0. No positive existence
proof is fabricated by these fixtures.

The final verification record and last historical crosswalk wording update
are documentation-only changes after that successful run; mathematical
sources, proof-admission implementation and metadata remain unchanged.
