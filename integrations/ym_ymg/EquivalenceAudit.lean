import YMGBridge.Solution
import YangMills.ExistenceOnly

set_option autoImplicit false
set_option warningAsError true

/-!
# Logical status of the two existence propositions

This audit uses the actual compiled source theorem and the unchanged ym-lean
target. It proves neither the target nor its negation. In particular, these
reductions must not be presented as an equivalence or inequivalence proof.

Since the source proposition already has a proof, any proposition implies it.
Consequently, equivalence with ym-lean's target is equivalent to proving that
target, and inequivalence is equivalent to refuting it. The reverse implication
below does not transport a ym-lean witness into a Wilson construction: it uses
the independently proved source theorem.

The final reduction identifies what an inequivalence proof would require:
an actual compact simple gauge group for which no native candidate can exist.
A source witness that fails a proposed translation is not such a counterexample.

Compile after building both projects and the staged source translation, with
the stage and source build directories added to LEAN_PATH, using:
  lake env lean integrations/ym_ymg/EquivalenceAudit.lean
-/

namespace YMGBridge.EquivalenceAudit
universe u

/-- A logical implication using the existing source proof, not a witness map. -/
theorem source_of_ymLean
    (_ : YangMills.YangMillsExistenceOnly.{u}) :
    PresentedJointExistence.{u} :=
  jointExistence

/-- Proving the forward implication would prove the entire native target. -/
theorem forward_iff_ymLean :
    (PresentedJointExistence.{u} → YangMills.YangMillsExistenceOnly.{u}) ↔
      YangMills.YangMillsExistenceOnly.{u} := by
  constructor
  · intro bridge
    exact bridge jointExistence
  · intro target _source
    exact target

/-- Exact equivalence reduces to native existence, which this file does not prove. -/
theorem equivalence_iff_ymLean :
    (PresentedJointExistence.{u} ↔ YangMills.YangMillsExistenceOnly.{u}) ↔
      YangMills.YangMillsExistenceOnly.{u} := by
  constructor
  · intro equivalence
    exact equivalence.mp jointExistence
  · intro target
    exact ⟨fun _source => target, source_of_ymLean⟩

/-- Different definitions alone cannot supply this refutation. -/
theorem inequivalence_iff_not_ymLean :
    (¬ (PresentedJointExistence.{u} ↔ YangMills.YangMillsExistenceOnly.{u})) ↔
      ¬ YangMills.YangMillsExistenceOnly.{u} := by
  constructor
  · intro inequivalence target
    exact inequivalence (equivalence_iff_ymLean.mpr target)
  · intro notTarget equivalence
    exact notTarget (equivalence.mp jointExistence)

/-- Refutation requires ruling out every candidate for at least one group. -/
theorem not_ymLean_iff_empty_candidate :
    (¬ YangMills.YangMillsExistenceOnly.{u}) ↔
      ∃ G : YangMills.CompactSimpleGaugeGroup.{u},
        IsEmpty (YangMills.FilteredExistenceCandidate G) := by
  classical
  constructor
  · intro notTarget
    change ¬ (∀ G : YangMills.CompactSimpleGaugeGroup.{u},
      Nonempty (YangMills.FilteredExistenceCandidate G)) at notTarget
    obtain ⟨G, noCandidate⟩ := not_forall.mp notTarget
    exact ⟨G, ⟨fun candidate => noCandidate ⟨candidate⟩⟩⟩
  · rintro ⟨G, noCandidate⟩ target
    obtain ⟨candidate⟩ := target G
    exact noCandidate.false candidate

/-- A criterion for a genuine counterexample, not an exhibited counterexample. -/
theorem inequivalence_iff_empty_candidate :
    (¬ (PresentedJointExistence.{u} ↔ YangMills.YangMillsExistenceOnly.{u})) ↔
      ∃ G : YangMills.CompactSimpleGaugeGroup.{u},
        IsEmpty (YangMills.FilteredExistenceCandidate G) :=
  inequivalence_iff_not_ymLean.trans not_ymLean_iff_empty_candidate

end YMGBridge.EquivalenceAudit
