import YangMills.ExistenceOnly

set_option backward.isDefEq.respectTransparency false
set_option warningAsError true

/-!
# An existence-only kinematic bridge for the October YM-ymg construction

This module does not import or certify the external construction.  It makes
precise which *physical QFT* data would have to be transported from its
selected Wightman reconstruction into the present existence-only target.

There is NO mass-gap hypothesis. A centered nonzero trace operator, together
with cyclicity and Wightman axioms, yields a genuine field-generated excitation.
A nonzero *uncentered* operator (such as the identity) would not suffice.

The source projects currently use different Lean/Mathlib versions.  The
source-facing translation of its chosen physical Wightman theory, the
full vacuum-word kernels and its centered trace field remains a separate
proof obligation.  No source theorem is imported by this module.
-/

noncomputable section
namespace YangMills

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

namespace WightmanData

/-- A nonzero two-point vacuum word of two actual fields, with the left
one-point word centered, produces an excitation *outside* the vacuum line.
This is an algebraic implication on the same state space: no spectral
assumption, gap, auxiliary vacuum, or unrelated field is used.

Unlike a bare assertion that a smeared field operator is nonzero, the
hypotheses exclude the identity-only representation. -/
theorem hasFieldExcitation_of_centered_twoPoint
    (Q : WightmanData H) (i j : Q.FieldIndex)
    (f g : TestFunction)
    (centered : inner ℂ (Q.vacuum : H) (Q.field i f Q.vacuum : H) = 0)
    (twoPoint : inner ℂ (Q.vacuum : H)
      (Q.field i f (Q.field j g Q.vacuum) : H) ≠ 0) :
    Q.HasFieldExcitation := by
  refine ⟨[(j, g)], ?_⟩
  change (Q.field j g Q.vacuum : H) ∉
    Submodule.span ℂ {(Q.vacuum : H)}
  intro hmem
  obtain ⟨c, hc⟩ := Submodule.mem_span_singleton.mp hmem
  have hstate : Q.field j g Q.vacuum = c • Q.vacuum :=
    Subtype.ext hc.symm
  apply twoPoint
  rw [hstate, map_smul]
  simp only [Submodule.coe_smul, inner_smul_right, centered, mul_zero]

/-- A *faithful centered field* in a cyclic Wightman theory forces an
actual field excitation without first converting Euclidean two-point
asymptotics into nonzero Minkowski vacuum words.

This is useful for the October YM-ymg source: its reconstruction provides
cyclicity and faithfulness, while its selected centered stress trace is
proved nonzero as a quotient field.  The external identification of that
field with the one here must still be checked. -/
theorem hasFieldExcitation_of_centered_faithful
    (Q : WightmanData H) (hQ : WightmanAxioms H Q) (i : Q.FieldIndex)
    (centered : ∀ f : TestFunction,
      inner ℂ (Q.vacuum : H) (Q.field i f Q.vacuum : H) = 0)
    (faithful : ∃ f : TestFunction, Q.field i f ≠ 0) :
    Q.HasFieldExcitation := by
  obtain ⟨f, hf⟩ := faithful
  by_contra hnot
  have htrivial : ¬ Q.HasNonVacuumState := by
    intro hv
    exact hnot (hQ.hasFieldExcitation_iff.mpr hv)
  have allVacuum (v : H) : ∃ c : ℂ, c • (Q.vacuum : H) = v := by
    apply Submodule.mem_span_singleton.mp
    by_contra hv
    exact htrivial ⟨v, hv⟩
  have hvac : (Q.vacuum : H) ≠ 0 := by
    intro hz
    have hn := hQ.vacuum_norm
    rw [hz, norm_zero] at hn
    exact zero_ne_one hn
  have hinner : inner ℂ (Q.vacuum : H) (Q.vacuum : H) ≠ 0 :=
    inner_self_ne_zero.mpr hvac
  obtain ⟨c, hc⟩ := allVacuum (Q.field i f Q.vacuum : H)
  have hc_zero : c = 0 := by
    have heq := congrArg (fun x : H => inner ℂ (Q.vacuum : H) x) hc
    rw [inner_smul_right, centered f] at heq
    exact (mul_eq_zero.mp heq).resolve_right hinner
  have hfieldVac : Q.field i f Q.vacuum = 0 := by
    apply Subtype.ext
    change (Q.field i f Q.vacuum : H) = 0
    calc
      _ = c • (Q.vacuum : H) := hc.symm
      _ = 0 := by simp [hc_zero]
  have hzero : Q.field i f = 0 := by
    apply LinearMap.ext
    intro v
    obtain ⟨a, ha⟩ := allVacuum (v : H)
    have hv : v = a • Q.vacuum := Subtype.ext ha.symm
    simp only [LinearMap.zero_apply]
    rw [hv, map_smul, hfieldVac, smul_zero]
  exact hf hzero

end WightmanData

/-- Precisely the *kinematic* part of a `FilteredExistenceCandidate`.
This does not assert group-dependent Yang--Mills identification, the
generated perturbative sector, or a mass gap. -/
structure ExistenceKinematics where
  theory : QuantumTheory
  qft_axioms : WightmanAxioms theory.State theory.fields
  fieldExcitation : theory.fields.HasFieldExcitation
  vacuumKernels : WightmanVacuumKernels theory.fields

/-- A source-facing boundary certificate.  The selected trace is a field
of the very Wightman theory being transported; no independent continuum
correlator or QFT may be chosen.

To instantiate this for YM-ymg, a separate adapter must transport its
proved Wightman axioms, selected phase's actual joint-Schwartz kernels,
and a nonzero *smeared operator* of the centered trace. -/
structure CenteredTraceKinematicInput where
  theory : QuantumTheory
  qft_axioms : WightmanAxioms theory.State theory.fields
  vacuumKernels : WightmanVacuumKernels theory.fields
  traceIndex : theory.fields.FieldIndex
  centered : ∀ f : TestFunction,
    inner ℂ (theory.fields.vacuum : theory.State)
      (theory.fields.field traceIndex f theory.fields.vacuum : theory.State) = 0
  nonzeroTraceField : ∃ f : TestFunction,
    theory.fields.field traceIndex f ≠ 0

/-- Construct the actual existence-only kinematic witness, discharging the
non-vacuum field-excitation clause *from a centered nonzero field*.
The rest of the YM identification remains outside this theorem. -/
def CenteredTraceKinematicInput.toExistenceKinematics
    (S : CenteredTraceKinematicInput) : ExistenceKinematics where
  theory := S.theory
  qft_axioms := S.qft_axioms
  vacuumKernels := S.vacuumKernels
  fieldExcitation := by
    exact S.theory.fields.hasFieldExcitation_of_centered_faithful
      S.qft_axioms S.traceIndex S.centered S.nonzeroTraceField

/-- This projection certifies that the intermediate target is exactly the
Wightman/field-excitation/full-kernel portion of the existing gap-free
`FilteredExistenceCandidate`.  The group-dependent generated sector is NOT
provided by the external kinematic input. -/
def FilteredExistenceCandidate.toExistenceKinematics
    {G : CompactSimpleGaugeGroup} (C : FilteredExistenceCandidate G) :
    ExistenceKinematics where
  theory := C.theory
  qft_axioms := C.qft_axioms
  fieldExcitation := C.fieldExcitation
  vacuumKernels := C.vacuumKernels

end YangMills
