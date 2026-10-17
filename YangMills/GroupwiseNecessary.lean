import YangMills.Statement

/-!
# Group quantifier alone is NOT Yang–Mills identification

The Clay statement is universally quantified over compact simple gauge
groups. The formula below makes that quantifier explicit but does not couple
G to any gauge-invariant quantum operator. The theorem proves that exactly
this construction is too weak: a *single* unrelated gapped QFT may be reused
for every group. No full-Clay certification must accept this statement.
-/

noncomputable section

namespace YangMills

universe u

/-- Necessary QFT-only shadow of the PDF's groupwise existence theorem.
This is intentionally **not** called Yang–Mills existence. -/
def GroupwiseQFTExistenceAndMassGap : Prop :=
  ∀ _G : CompactSimpleGaugeGroup.{u},
    ∃ Q : QuantumTheory, GappedWightmanTheory Q.State Q.fields

/-- Demonstrates the dangerous weakening: quantifying a group that the
quantum theory never uses gives nothing beyond one gapped QFT, even before
Yang–Mills identification, nontriviality or UV/OPE conditions are imposed. -/
theorem qft_exists_implies_groupwise_qft
    (h : QFTExistenceAndMassGap) :
    GroupwiseQFTExistenceAndMassGap := by
  intro _G
  exact h

end YangMills
