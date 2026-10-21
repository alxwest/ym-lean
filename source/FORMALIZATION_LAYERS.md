# Provenance and readiness are different

The pinned Jaffe–Witten source is §4, printed p.6, together with its action,
QFT context and cited mathematical standards. Each source registry row has
an acceptance role and a provenance classification. These classifications
are not physics premises and are not readiness states.

- `literal_form` identifies directly written mathematical shape, such as the
  universal group quantifier, full R4 or the physical spectral mass interval.
- `cited_framework` identifies a meaning delegated to an axiom system, such as
  the complete Wightman formulation.
- The legacy enum `interpretation_needed` identifies a phrase that requires
  interpretive mathematical judgment. Its meaning is now fixed and reviewed
  in the full assembled specification; the enum does not say a definition is
  still missing.
- `nonbinding_guidance` preserves §4 footnote 1 as guidance about observable
  filtrations, rather than a compulsory classical/quantum isomorphism.

`YangMills/SourceClassification.lean` records declaration origins. Its
`interpretiveScope` list documents choices; the legacy name
`interpretationStillNeeded` is a compatibility alias, not a gap list. Optional
lattice/holonomy and other construction lemmas remain optional methods.

Current readiness and its reviewed sufficiency argument are recorded in
`FINAL_FIDELITY_ARGUMENT.md` and the current source/adversarial crosswalks.
The verifier separately checks fixed source roles, trusted review activation,
the actual compiled exact target shape and any submitted proof. Metadata,
labels, compilation and agent consensus alone do not prove semantic fidelity.
No interpretation supplies an existence assumption, and no kernel result
asserts external acceptance.
