import YangMills.Spectrum

/-!
# Yang–Mills existence and mass gap: a statement interface

Reading order follows Arthur Jaffe and Edward Witten, *Quantum Yang–Mills
Theory*, §§1, 3, 4 (the local reference is `source/yangmills.pdf`).
https://www.claymath.org/wp-content/uploads/2022/06/yangmills.pdf

STATUS: this is a parameterized statement, not a complete foundational
formalization of quantum Yang–Mills theory. `Framework` exposes the missing
analytic/geometric definitions as parameters. Its predicates are NOT axioms
asserting those properties. An arbitrary implementation (e.g. setting them
to `True`) does not constitute a formalization of the Millennium problem.
No proof of the conjecture is postulated or supplied.
-/

namespace YangMills

/-- Four real coordinates. The QFT interface must supply the Euclidean or
Minkowski geometry appropriate to its axiom scheme. -/
abbrev Spacetime := Fin 4 → ℝ

/-- Prerequisite interface, with the intended mathematical obligations listed
at each field. These obligations still require concrete definitions and proofs.
Keeping them outside the existential theory prevents silently choosing the
meaning of “Yang–Mills” after choosing a candidate solution. -/
structure Framework where
  /-- §1: a universe of finite-dimensional real Lie groups with their smooth
  and topological structures, including all groups covered by the problem. -/
  GaugeGroup : Type
  /-- Compact simple gauge group in the Lie-theoretic sense. Do not substitute
  abstract-group simplicity: finite central subgroups are allowed (e.g. SU(n)).
  A concrete implementation must specify its connectedness convention. -/
  compactSimple : GaugeGroup → Prop
  /-- Candidate continuum theories indexed by gauge group and spacetime.
  A finite lattice or finite-volume theory alone is not a candidate on ℝ⁴. -/
  Theory : GaugeGroup → Type → Type

  /-- §3 and §4: axiomatic QFT at least as strong as the cited Wightman or
  Osterwalder–Schrader framework (with reconstruction in the Euclidean route).
  Includes a Hilbert space, covariant operator-valued distributions on a
  suitable common dense domain, locality, the spectral condition, and a cyclic
  Poincaré-invariant vacuum unique up to phase. This is a semantic interface,
  not an implementation of either complete axiom system. -/
  axiomaticQFT : {G : GaugeGroup} → Theory G Spacetime → Prop

  /-- §4, first paragraph and footnote: local quantum observables corresponding
  to gauge-invariant polynomials in curvature F and its covariant derivatives.
  The correspondence must respect renormalization/operator mixing and the
  dimension filtration; a naive pointwise bijection is not required. -/
  localGaugeObservables : {G : GaugeGroup} → Theory G Spacetime → Prop

  /-- §§1,4: the theory quantizes pure Yang–Mills for G, with classical action
  (1/(4g²)) ∫ Tr(F ∧ ⋆F), F = dA + A ∧ A, and positive coupling g.
  This must link the observables and dynamics to G, not merely attach a label.
  No matter fields or Higgs mechanism are part of this problem. -/
  pureYangMillsDynamics : {G : GaugeGroup} → Theory G Spacetime → Prop

  /-- §4: short-distance correlation functions agree with asymptotic freedom
  and perturbative renormalization, including a stress tensor and an operator
  product expansion with the predicted local singularities. Specifying the
  precise asymptotics remains part of implementing this predicate. -/
  ultravioletBehavior : {G : GaugeGroup} → Theory G Spacetime → Prop

  /-- §4: non-triviality of the quantum theory. This is deliberately a separate
  semantic obligation, not defined as merely having a nonzero Hilbert space
  or a positive gap. A concrete formalization must justify its interpretation. -/
  nontrivial : {G : GaugeGroup} → Theory G Spacetime → Prop

  /-- Full real spectrum of the (generally unbounded) Hamiltonian H. -/
  energySpectrum : {G : GaugeGroup} → Theory G Spacetime → Set ℝ
  /-- Links `energySpectrum` to the self-adjoint generator of time translations
  of this very QFT, with vacuum HΩ = 0. This prevents treating an unrelated
  set of real numbers as its Hamiltonian spectrum. -/
  hamiltonianRealization : {G : GaugeGroup} → Theory G Spacetime → Prop

/-- The existence requirements preceding the highlighted problem in §4.
Each field is a proof obligation, rather than a freely chosen truth value. -/
structure IsQuantumYangMills (F : Framework) (G : F.GaugeGroup)
    (Q : F.Theory G Spacetime) : Prop where
  axioms : F.axiomaticQFT Q
  observables : F.localGaugeObservables Q
  dynamics : F.pureYangMillsDynamics Q
  shortDistance : F.ultravioletBehavior Q
  nontrivial : F.nontrivial Q
  hamiltonian : F.hamiltonianRealization Q
  positiveEnergy : PositiveEnergy (F.energySpectrum Q)
  vacuumEnergy : 0 ∈ F.energySpectrum Q

/-- §4: for every compact simple gauge group, construct a non-trivial quantum
Yang–Mills theory on ℝ⁴ with a positive, finite mass.

Read `∀` as “for every”, `→` as “if … then”, `∃` as “there exists”, and `∧`
as “and”. The gap and the theory may depend on G; there is no uniform gap
assertion over all gauge groups.

This declaration defines a proposition. It does not prove it, assume it as an
axiom, or hide an unfinished proof behind `sorry`. It becomes a faithful target
only after supplying a faithful concrete `Framework`.
-/
def YangMillsExistenceAndMassGap (F : Framework) : Prop :=
  ∀ G : F.GaugeGroup, F.compactSimple G →
    ∃ Q : F.Theory G Spacetime,
      IsQuantumYangMills F G Q ∧
      HasPositiveFiniteMass (F.energySpectrum Q)

-- §5 discusses further goals, such as confinement and an isolated particle
-- state. They are not added to the existence-and-gap statement above.

end YangMills
