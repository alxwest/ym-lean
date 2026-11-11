import YangMills.YMYMGSpacetimeBridge
import YangMills.WightmanVacuumKernels

set_option backward.isDefEq.respectTransparency false
set_option warningAsError true

/-!
# All-arity physical-kernel transport: exact remaining interface

The October source provides full joint-Schwartz physical distributions
on its own time-last `Points n` space. The target's
`WightmanVacuumKernels` requires those continuous functionals on
time-first full Schwartz spaces and equality with actual physical
vacuum words on product tests.

The continuous Schwartz transport is proved in YMYMGSpacetimeBridge.
What remains as hypotheses below is the SOURCE's actual selected
vacuum-word identity for the SAME Wightman Q and tensor-test density.
Neither is inferred merely from Euclidean separated correlations.
No positive mass gap or extraneous QFT is introduced.
-/

noncomputable section
namespace YangMills

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- Every field is tied to one actual physical Wightman Q. The source
supplies its joint-Schwartz continuous functionals in YM-ymg coordinates.
The finite-product tensor density and actual-word identification are
explicit, reviewable obligations, not hidden assumptions. -/
structure YmymgFullKernelInput (Q : WightmanData H) where
  tensor : (n : ℕ) → (Fin n → TestFunction) → VacuumNPointTest n
  tensor_eq : ∀ n tests x, tensor n tests x = ∏ i, tests i (x i)
  tensor_dense : ∀ n, Dense ((Submodule.span ℂ
    (Set.range (tensor n))) : Set (VacuumNPointTest n))
  sourceKernels : (n : ℕ) → (Fin n → Q.FieldIndex) →
    (SchwartzMap (YmymgJointPoints n) ℂ →L[ℂ] ℂ)
  actual_source_words : ∀ n indices tests,
    sourceKernels n indices (ymymgJointPullback n (tensor n tests)) =
      Q.vacuumNPoint (List.ofFn fun i => (indices i, tests i))

/-- Exact construction of the target's full Schwartz vacuum kernel
certificate from the SOURCE's full Schwartz distributions and their
physically checked word pairings. This is not a claim the source has
already provided this entire input. -/
def YmymgFullKernelInput.toWightmanVacuumKernels
    {Q : WightmanData H} (D : YmymgFullKernelInput Q) :
    WightmanVacuumKernels Q where
  tensor := D.tensor
  tensor_eq := D.tensor_eq
  tensor_dense := D.tensor_dense
  kernel n indices := ymymgJointKernelToTarget n (D.sourceKernels n indices)
  actual_words := by
    intro n indices tests
    exact D.actual_source_words n indices tests

/-- Pointwise statement of the source→target full Schwartz distribution
conversion, with no off-diagonal restriction. -/
theorem YmymgFullKernelInput.kernel_transport
    {Q : WightmanData H} (D : YmymgFullKernelInput Q)
    (n : ℕ) (indices : Fin n → Q.FieldIndex)
    (test : VacuumNPointTest n) :
    (D.toWightmanVacuumKernels.kernel n indices) test =
      D.sourceKernels n indices (ymymgJointPullback n test) := rfl

/-- Two admissible source full-Schwartz distributions that give the
same actual QFT vacuum words cannot disagree on hidden contact terms.
This follows from actual target-kernel uniqueness and the proved
reversible continuous transport. -/
theorem YmymgFullKernelInput.source_kernel_unique
    {Q : WightmanData H} (D E : YmymgFullKernelInput Q)
    (n : ℕ) (indices : Fin n → Q.FieldIndex) :
    D.sourceKernels n indices = E.sourceKernels n indices := by
  have h := WightmanVacuumKernels.kernel_unique
    D.toWightmanVacuumKernels E.toWightmanVacuumKernels n indices
  have hback := congrArg (ymymgJointKernelToSource n) h
  simpa only [toWightmanVacuumKernels, ymymgJointKernelSourceTarget] using hback

end YangMills
