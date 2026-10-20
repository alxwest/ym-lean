# Central composite-field and stress-tensor definitions

These files add central necessary mathematical relations, not an exact full Jaffe–Witten specification or an existence proof.

## Concrete same-theory correspondence

`FiniteFieldCombination Q` is a finitely supported complex coefficient vector over Q's actual field components. Its `.field` is the actual finite linear combination of those operator-valued distributions on Q's original common invariant domain. Continuity is proved from Q's field continuity, and locality is proved from the same Q's local commutativity.

`RenormalizedCompositeMap Q G` takes the actual G-invariant curvature-jet polynomial algebra into these finite combinations, linearly over the real coefficients of the classical algebra, at each positive renormalization scale. `Compatible` fixes operator identities under equality of classical evaluations on all smooth connections, the identity field, Hermitian conjugation of real polynomials, distributional derivative descendants, and cyclicity of the identified composite fields in Q's physical Hilbert space. Cyclicity is for C's fields, not merely all unrelated Q fields; adjoining a decoupled extra theory cannot contribute a hidden smaller mass gap.

`IsClassicalDerivative` is an actual directional derivative of evaluated smooth classical functions. The descendant condition uses mathlib's actual continuous Schwartz-space directional derivative. It does not let an author choose what “descendant” means.

`intrinsicEngineeringDimension` is the minimum degree in the quotient filtration by equality on actual smooth connections. Its characterization theorem proves this is the least bound. Caller-selected high upper bounds cannot weaken mixing or OPE scaling.

`FiniteMixing` is an invertible finite matrix relating actual operators, with intrinsic-degree triangularity and explicit renormalization-scale factors μ^(d_i-d_j). Its convention is O'_i=Σ_j μ^(d_i-d_j) M_ij O_j. It neither makes the correspondence injective nor requires a bijection between classical polynomials and quantum fields. It defines a permitted finite mixing relation; it is not imposed as a universal exact filtered isomorphism between all classical and quantum operators.

`Connection.poincarePullback` constructs the actual smooth affine pullback one-form. `IsClassicalPoincareTransform` fixes transformed polynomial labels by evaluation on these pulled-back connections at the inverse-transformed point. `Compatible.covariance` requires an actual invariant polynomial witness and its exact quantum intertwiner equation; it cannot pass through a vacuous implication. `classicalPoincareTransform_unique` proves uniqueness modulo actual connection identities. Constructing the transformed invariant polynomial universally from an explicit finite substitution is still a supporting algebraic/geometric lemma, not Yang–Mills existence.

Remaining central correspondence work: that explicit polynomial substitution and derivative-descendant construction; full symmetry/BRST-compatible finite renormalization; connection of C to the group-dependent prescribed perturbative coefficients and asymptotic freedom. Without the last condition an unrelated massive QFT could still admit formal label assignments. No readiness claim is made.

## Stress tensor and actual translations

`StressTensorData` labels 16 composites of intrinsic dimension at most four from this same C. `Compatible` fixes symmetry, rank-two Lorentz covariance, and distributional conservation via derivatives of Schwartz test functions. It requires weak global charges on a common graph core to converge to the actual coordinate-translation generators. The time generator is literally Q's existing Hamiltonian, whose spectrum defines the mass gap.

The Fourier convention is U(a)=exp(iP·a), with metric (+---). The generator of the spatial coordinate-translation parameter is therefore minus the contravariant physical momentum. The charge condition includes `metricSign μ` explicitly; its time component remains the physical Hamiltonian.

The charge core lies inside Q's common operator domain and every generator domain. It is a graph core for every generator, not merely Hilbert-dense. Schwartz time smearing has unit integral, and spatial cutoffs are compactly supported and identically one in the unit ball before radius rescaling. Their actual pointwise factorization is imposed. No sharp-time restriction of an operator-valued distribution is assumed. An admissible smearing is supplied with a proof of its explicit conditions, so charge conditions cannot pass through an empty cutoff class.

Two supporting theorems show the central anti-vacuity property: an identically zero tensor forces every actual translation generator to be zero; consequently it cannot satisfy the required conditions together with a positive finite physical mass. These are consequences of weak charge limits, dense Q domain, graph-core approximation, self-adjointness, and the actual operator resolvent.

A fidelity qualification remains: existence of this chosen graph-core/weak-charge presentation for every source-admissible stress tensor is not yet proved. It is a precise, physically standard presentation to review, not an established scheme-independent equivalence theorem.

## Trace anomaly repair and unresolved fixed prescription

An initial candidate required T to be the exact linear image C of the classically traceless four-dimensional stress polynomial. Adversarial review correctly rejected this: C's real linearity and respect for classical identities would then force the quantum trace to vanish, excluding the trace anomaly. That requirement was removed before integration.

`classicalStress` still gives the explicit (+---) classical expression needed as a leading perturbative symbol. The actual quantum tensor is determined by its physical tensor/conservation/charge identities; it may mix with scalar dimension-four composites and have a nonzero trace.

`HasTraceAnomaly T betaValue curvatureSquare` writes the explicit equation

  Σ_μ η_μμ T^(μμ)(f) = betaValue/(2 g^3) C([B(F,F)])(f)

in the convention L=-B(F,F)/(4g²), using T's own invariant form, positive coupling, scale, and C map. The curvature-square label must evaluate to the actual fixed Lorentzian contraction on every smooth connection. This is a concrete conditional relation, not a completed definition of the Yang–Mills beta function: a final target must obtain betaValue from the fixed group-dependent renormalized perturbative prescription, constrain it by the appropriate RG equations, and identify the leading classical tensor. Quantifying over an arbitrary betaValue as “prescribed predictions” would remain unacceptable.

Primary-source basis: Jaffe–Witten §4 requires renormalized local operators and the stress tensor; its footnote rejects naive classical/quantum matching. The available primary Itzykson–Zuber extract `work/iz-relevant.txt`, printed pp.679–680, eqs.(13-159)–(13-163), normalizes conserved currents by their generators/Ward identities and explains their vanishing anomalous dimension. The graph-core and smearing presentation is an explicit mathematical choice requiring further sufficiency/equivalence justification, not language literally specified by those pages.

## Verification

The two files compile using the pinned Lean 4.25.0/mathlib environment with autoImplicit=false and warningAsError=true. No `sorry`, new axioms, free Prop inputs, or assumed existence conclusions are introduced. Integration must run the complete build and trusted transitive-axiom audit. Build success does not establish semantic fidelity or close the fixed renormalized perturbative/UV/OPE definitions.

Seven central supporting theorem axiom audits (`CompositeAudit.lean`, `StressAudit.lean`) returned only `propext`, `Classical.choice`, and `Quot.sound`. These local audits supplement, rather than replace, the repository's trusted integration inspector.
