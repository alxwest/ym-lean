import YangMills.QFT.Spacetime
import Mathlib.Analysis.InnerProductSpace.PiL2

set_option warningAsError true
set_option autoImplicit false

/-!
# October YM-ymg source-coordinate conversion

YM-ymg's `PublicTheory.Spacetime` is definitionally
`EuclideanSpace ℝ (Fin 4)` with physical time at `Fin.last 3`.
The existence-only ym-lean specification uses `Fin 4 → ℝ`
with physical time at index 0.

This is an actual invertible coordinate conversion over their shared
mathematical scalar/space types. It does not import the older Lean 4.32.0
source or assert that the full Poincare/Schwartz/Hamiltonian interfaces
have been transported. 
-/

noncomputable section
namespace YangMills

/-- Reindex physical time at source coordinate 3 to target coordinate 0.
The two remaining swapped spatial coordinates merely relabel axes. -/
def ymymgToTargetPoint (x : EuclideanSpace ℝ (Fin 4)) : Spacetime :=
  fun i => x ((Equiv.swap (0 : Fin 4) 3) i)

/-- The same transposition is its own inverse. -/
def targetToYmymgPoint (x : Spacetime) : EuclideanSpace ℝ (Fin 4) :=
  WithLp.toLp 2 fun i => x ((Equiv.swap (0 : Fin 4) 3) i)

@[simp] theorem targetToYmymg_ymymgToTarget (x : EuclideanSpace ℝ (Fin 4)) :
    targetToYmymgPoint (ymymgToTargetPoint x) = x := by
  apply PiLp.ext
  intro i
  change x ((Equiv.swap (0 : Fin 4) 3)
    ((Equiv.swap (0 : Fin 4) 3) i)) = x i
  rw [Equiv.swap_apply_self]

@[simp] theorem ymymgToTarget_targetToYmymg (x : Spacetime) :
    ymymgToTargetPoint (targetToYmymgPoint x) = x := by
  funext i
  change x ((Equiv.swap (0 : Fin 4) 3)
    ((Equiv.swap (0 : Fin 4) 3) i)) = x i
  rw [Equiv.swap_apply_self]

def ymymgTargetPointEquiv : EuclideanSpace ℝ (Fin 4) ≃ Spacetime where
  toFun := ymymgToTargetPoint
  invFun := targetToYmymgPoint
  left_inv := targetToYmymg_ymymgToTarget
  right_inv := ymymgToTarget_targetToYmymg

/-- Source `timeAxis = Fin.last 3`, target time is index 0. -/
theorem ymymgToTarget_time (x : EuclideanSpace ℝ (Fin 4)) :
    ymymgToTargetPoint x 0 = x (Fin.last 3) := by
  simp [ymymgToTargetPoint]

/-- The source's raw Minkowski bilinear form in its native
(time-last) coordinates. The public source's `minkowskiSquare` uses
this form on the diagonal, written via the Euclidean norm. -/
def ymymgRawMinkowski (x y : EuclideanSpace ℝ (Fin 4)) : ℝ :=
  x 3 * y 3 - (x 0 * y 0 + x 1 * y 1 + x 2 * y 2)

/-- This coordinate conversion exactly preserves the (+---) Minkowski
bilinear form. There is no additional sign or coupling normalization. -/
theorem ymymgToTarget_minkowski (x y : EuclideanSpace ℝ (Fin 4)) :
    minkowski (ymymgToTargetPoint x) (ymymgToTargetPoint y) =
      ymymgRawMinkowski x y := by
  simp [minkowski, ymymgToTargetPoint, ymymgRawMinkowski,
    Fin.sum_univ_succ, Equiv.swap_apply_def]
  ring

/-- YM-ymg's source `spatial` map: the first three (time-last)
coordinates with their Euclidean L² norm. -/
def ymymgSourceSpatial (x : EuclideanSpace ℝ (Fin 4)) :
    EuclideanSpace ℝ (Fin 3) :=
  WithLp.toLp 2 fun i => x i.castSucc

/-- Source `minkowskiSquare` (equivalent to its PublicTheory definition)
through the original time-last Euclidean norm convention. -/
def ymymgSourceMinkowskiSquare (x : EuclideanSpace ℝ (Fin 4)) : ℝ :=
  (x (Fin.last 3)) ^ 2 - ‖ymymgSourceSpatial x‖ ^ 2

/-- The algebraic quadratic form above coincides with the source's
time-last Minkowski-square expression, including its spatial norm. -/
theorem ymymgRawMinkowski_square_eq (x : EuclideanSpace ℝ (Fin 4)) :
    ymymgRawMinkowski x x = ymymgSourceMinkowskiSquare x := by
  unfold ymymgRawMinkowski ymymgSourceMinkowskiSquare
  rw [EuclideanSpace.real_norm_sq_eq]
  simp [ymymgSourceSpatial, Fin.sum_univ_succ]
  ring

/-- The full metric conversion agrees with the source's norm-based
Minkowski square, not merely with an ad hoc polynomial. -/
theorem ymymgToTarget_minkowskiSquare (x : EuclideanSpace ℝ (Fin 4)) :
    minkowski (ymymgToTargetPoint x) (ymymgToTargetPoint x) =
      ymymgSourceMinkowskiSquare x := by
  rw [ymymgToTarget_minkowski]
  exact ymymgRawMinkowski_square_eq x

/-- Algebraic form of the future light cone condition. -/
private theorem norm_le_of_square_nonneg (s t : ℝ) (hs : 0 ≤ s) :
    s ≤ t ↔ 0 ≤ t ∧ 0 ≤ t ^ 2 - s ^ 2 := by
  constructor
  · intro hst
    constructor
    · exact le_trans hs hst
    · nlinarith
  · rintro ⟨ht, hsq⟩
    nlinarith

/-- YM-ymg's norm-based forward cone and ym-lean's spectrum forward
cone agree *exactly* after swapping the time-coordinate labels. -/
theorem ymymgSource_forwardCone_iff (x : EuclideanSpace ℝ (Fin 4)) :
    ‖ymymgSourceSpatial x‖ ≤ x (Fin.last 3) ↔
      ymymgToTargetPoint x ∈ FutureCone := by
  change _ ↔ (0 ≤ ymymgToTargetPoint x 0 ∧
    0 ≤ minkowski (ymymgToTargetPoint x) (ymymgToTargetPoint x))
  rw [ymymgToTarget_time, ymymgToTarget_minkowskiSquare]
  unfold ymymgSourceMinkowskiSquare
  exact norm_le_of_square_nonneg _ _ (norm_nonneg _)

/-- Point subtraction commutes with the coordinate translation. -/
@[simp] theorem ymymgToTarget_sub (x y : EuclideanSpace ℝ (Fin 4)) :
    ymymgToTargetPoint (x - y) =
      ymymgToTargetPoint x - ymymgToTargetPoint y := by
  funext i
  rfl

/-- YM-ymg's native spacelike criterion is equivalent to the exact
ym-lean spacelike criterion after the coordinate change. -/
theorem ymymgSource_spacelike_iff (x y : EuclideanSpace ℝ (Fin 4)) :
    ymymgSourceMinkowskiSquare (x - y) < 0 ↔
    SpacelikeSeparated (ymymgToTargetPoint x)
      (ymymgToTargetPoint y) := by
  rw [SpacelikeSeparated, ← ymymgToTarget_sub,
    ymymgToTarget_minkowskiSquare]

end YangMills
