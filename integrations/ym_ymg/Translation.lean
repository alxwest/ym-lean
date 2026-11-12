import YMGSubmission.ChallengeSpec

set_option autoImplicit false
set_option warningAsError true

/-!
# Universe-independent presentations of the October source theorem

This translates the SOURCE statement, not `YangMillsExistenceOnly`.
The carrier may live in any universe and is related to the source's closed
matrix group by an actual continuous group isomorphism. The matrix group,
Wilson family, extraction order and full hierarchy properties are retained.

The round-trip theorem proves equivalence with `YMGSubmission.JointExistence`.
It does not construct a matrix presentation of every abstract compact Lie
group, or supply ym-lean's additional physical matching/transport obligations.
-/

noncomputable section
namespace YMGBridge
universe u

structure PresentedGaugeGroup where
  Carrier : Type u
  [group : Group Carrier]
  [topology : TopologicalSpace Carrier]
  matrix : YMGSubmission.GaugeGroup
  equivalence : Carrier ≃ₜ* matrix.image

attribute [instance] PresentedGaugeGroup.group PresentedGaugeGroup.topology

namespace PresentedGaugeGroup

/-- The actual faithful matrix representation of the potentially large carrier. -/
def representation (G : PresentedGaugeGroup) :
    G.Carrier →* YMGSubmission.UnitaryRepresentation G.matrix.n :=
  G.matrix.image.subtype.comp G.equivalence.toMulEquiv.toMonoidHom

theorem representation_injective (G : PresentedGaugeGroup) :
    Function.Injective G.representation :=
  Subtype.val_injective.comp G.equivalence.injective

theorem representation_continuous (G : PresentedGaugeGroup) :
    Continuous G.representation :=
  continuous_subtype_val.comp G.equivalence.continuous

theorem representation_range (G : PresentedGaugeGroup) :
    Set.range G.representation = (G.matrix.image : Set _) := by
  ext x
  constructor
  · rintro ⟨a, rfl⟩
    exact (G.equivalence a).property
  · intro hx
    refine ⟨G.equivalence.symm ⟨x, hx⟩, ?_⟩
    change (G.equivalence (G.equivalence.symm ⟨x, hx⟩)).val = x
    rw [G.equivalence.apply_symm_apply]

/-- Every original matrix group has a presentation in any universe. -/
def lift (g : YMGSubmission.GaugeGroup) : PresentedGaugeGroup.{u} where
  Carrier := ULift.{u} g.image
  matrix := g
  equivalence :=
    { Homeomorph.ulift with
      map_mul' := fun _ _ => rfl }

@[simp] theorem lift_matrix (g : YMGSubmission.GaugeGroup) :
    (lift.{u} g).matrix = g := rfl

end PresentedGaugeGroup

/-- The entire original conclusion for one group, with its original order of
quantifiers: one family before every volume sequence, then a shared hierarchy. -/
def SourceResult (g : YMGSubmission.GaugeGroup) : Prop :=
  g.IsSimple → ∃ C : YMGSubmission.WilsonFamily g,
    YMGSubmission.WilsonRegularity C ∧
      ∀ p : ℕ → ℕ, StrictMono p → ∃ q : ℕ → ℕ, StrictMono q ∧
        ∃ T : YMGSubmission.Hierarchy C, T.Properties (p ∘ q)

/-- Carrier-universe translation of the source statement. This is intentionally
a different target from ym-lean's proposed existence-only specification. -/
def PresentedJointExistence : Prop :=
  ∀ G : PresentedGaugeGroup.{u}, SourceResult G.matrix

theorem presentedJointExistence_iff_source :
    PresentedJointExistence.{u} ↔ YMGSubmission.JointExistence := by
  constructor
  · intro h g hg
    exact h (PresentedGaugeGroup.lift.{u} g) hg
  · intro h G hg
    exact h G.matrix hg

end YMGBridge
