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

/-- The time-axis permutation is a REAL-LINEAR isomorphism of the exact
source and target continuum point spaces. -/
def ymymgTargetLinearEquiv : EuclideanSpace ℝ (Fin 4) ≃ₗ[ℝ] Spacetime where
  toEquiv := ymymgTargetPointEquiv
  map_add' := by
    intro x y
    funext i
    rfl
  map_smul' := by
    intro a x
    funext i
    rfl

/-- Since both point spaces are finite-dimensional normed real vector spaces,
the coordinate equivalence and its inverse are automatically continuous. -/
def ymymgTargetContinuousLinearEquiv :
    EuclideanSpace ℝ (Fin 4) ≃L[ℝ] Spacetime :=
  ymymgTargetLinearEquiv.toContinuousLinearEquiv

/-- Transport any full single-point Schwartz test from the target to
the source coordinates, preserving the original Schwartz topology. -/
def ymymgPullbackSchwartz :
    SchwartzMap Spacetime ℂ →L[ℂ]
      SchwartzMap (EuclideanSpace ℝ (Fin 4)) ℂ :=
  SchwartzMap.compCLMOfContinuousLinearEquiv ℂ
    ymymgTargetContinuousLinearEquiv

/-- Transport source-coordinate Schwartz tests back to ym-lean's coordinates. -/
def ymymgPushforwardSchwartz :
    SchwartzMap (EuclideanSpace ℝ (Fin 4)) ℂ →L[ℂ]
      SchwartzMap Spacetime ℂ :=
  SchwartzMap.compCLMOfContinuousLinearEquiv ℂ
    ymymgTargetContinuousLinearEquiv.symm

/-- The source→target single-point Schwartz transport has a left inverse. -/
theorem ymymgSchwartz_pull_push
    (f : SchwartzMap (EuclideanSpace ℝ (Fin 4)) ℂ) :
    ymymgPullbackSchwartz (ymymgPushforwardSchwartz f) = f := by
  apply SchwartzMap.ext
  intro x
  change f (targetToYmymgPoint (ymymgToTargetPoint x)) = f x
  rw [targetToYmymg_ymymgToTarget]

/-- The target→source single-point Schwartz transport has a left inverse. -/
theorem ymymgSchwartz_push_pull (f : SchwartzMap Spacetime ℂ) :
    ymymgPushforwardSchwartz (ymymgPullbackSchwartz f) = f := by
  apply SchwartzMap.ext
  intro x
  change f (ymymgToTargetPoint (targetToYmymgPoint x)) = f x
  rw [ymymgToTarget_targetToYmymg]

/-- A continuously invertible transport of all one-point Schwartz
test functions. The two algebraic inverses above are continuous. -/
def ymymgSchwartzLinearEquiv :
    SchwartzMap (EuclideanSpace ℝ (Fin 4)) ℂ ≃ₗ[ℂ]
      SchwartzMap Spacetime ℂ :=
  LinearEquiv.mk ymymgPushforwardSchwartz.toLinearMap
    ymymgPullbackSchwartz ymymgSchwartz_pull_push ymymgSchwartz_push_pull

def ymymgSchwartzContinuousLinearEquiv :
    SchwartzMap (EuclideanSpace ℝ (Fin 4)) ℂ ≃L[ℂ]
      SchwartzMap Spacetime ℂ :=
  ContinuousLinearEquiv.mk ymymgSchwartzLinearEquiv
    ymymgPushforwardSchwartz.continuous ymymgPullbackSchwartz.continuous

/-- Exactly the source public `Points n` type (a finite L² product of
four-dimensional Euclidean points), with time as the last coordinate. -/
abbrev YmymgJointPoints (n : ℕ) :=
  PiLp 2 (fun _ : Fin n => EuclideanSpace ℝ (Fin 4))

/-- Source joint configuration → target ordered n-point configuration. -/
def ymymgJointToTarget (n : ℕ) (x : YmymgJointPoints n) :
    Fin n → Spacetime :=
  fun i => ymymgToTargetPoint (x i)

/-- Target ordered n-point configuration → source joint configuration. -/
def targetToYmymgJoint (n : ℕ) (x : Fin n → Spacetime) :
    YmymgJointPoints n :=
  WithLp.toLp 2 fun i => targetToYmymgPoint (x i)

@[simp] theorem targetToYmymgJoint_ymymgJointToTarget (n : ℕ)
    (x : YmymgJointPoints n) :
    targetToYmymgJoint n (ymymgJointToTarget n x) = x := by
  apply PiLp.ext
  intro i
  exact targetToYmymg_ymymgToTarget (x i)

@[simp] theorem ymymgJointToTarget_targetToYmymgJoint (n : ℕ)
    (x : Fin n → Spacetime) :
    ymymgJointToTarget n (targetToYmymgJoint n x) = x := by
  funext i
  exact ymymgToTarget_targetToYmymg (x i)

/-- The source's full joint-point data and the target's full n-point
data are linearly equivalent for every arity. -/
def ymymgJointLinearEquiv (n : ℕ) :
    YmymgJointPoints n ≃ₗ[ℝ] (Fin n → Spacetime) where
  toFun := ymymgJointToTarget n
  invFun := targetToYmymgJoint n
  left_inv := targetToYmymgJoint_ymymgJointToTarget n
  right_inv := ymymgJointToTarget_targetToYmymgJoint n
  map_add' := by
    intro x y
    funext i j
    rfl
  map_smul' := by
    intro a x
    funext i j
    rfl

/-- Finite-dimensionality supplies continuity of the source/target
n-point equivalence, without choosing a new Euclidean measure. -/
def ymymgJointContinuousLinearEquiv (n : ℕ) :
    YmymgJointPoints n ≃L[ℝ] (Fin n → Spacetime) :=
  (ymymgJointLinearEquiv n).toContinuousLinearEquiv

/-- Full Schwartz tests from the target n-point spacetime, pulled back
into the source's exact `Points n` coordinate type. -/
def ymymgJointPullback (n : ℕ) :
    SchwartzMap (Fin n → Spacetime) ℂ →L[ℂ]
      SchwartzMap (YmymgJointPoints n) ℂ :=
  SchwartzMap.compCLMOfContinuousLinearEquiv ℂ
    (ymymgJointContinuousLinearEquiv n)

/-- Source joint Schwartz tests become full target joint Schwartz tests.
This is not restricted to products or to the off-diagonal domain. -/
def ymymgJointPushforward (n : ℕ) :
    SchwartzMap (YmymgJointPoints n) ℂ →L[ℂ]
      SchwartzMap (Fin n → Spacetime) ℂ :=
  SchwartzMap.compCLMOfContinuousLinearEquiv ℂ
    (ymymgJointContinuousLinearEquiv n).symm

theorem ymymgJointPull_push (n : ℕ)
    (f : SchwartzMap (YmymgJointPoints n) ℂ) :
    ymymgJointPullback n (ymymgJointPushforward n f) = f := by
  apply SchwartzMap.ext
  intro x
  change f (targetToYmymgJoint n (ymymgJointToTarget n x)) = f x
  rw [targetToYmymgJoint_ymymgJointToTarget]

theorem ymymgJointPush_pull (n : ℕ)
    (f : SchwartzMap (Fin n → Spacetime) ℂ) :
    ymymgJointPushforward n (ymymgJointPullback n f) = f := by
  apply SchwartzMap.ext
  intro x
  change f (ymymgJointToTarget n (targetToYmymgJoint n x)) = f x
  rw [ymymgJointToTarget_targetToYmymgJoint]

/-- A continuous linear equivalence of full joint Schwartz spaces,
for EVERY arity, provided the source's continuum test type is the
`SchwartzMap (Points n) ℂ` type used by its boundary reconstruction. -/
def ymymgJointSchwartzLinearEquiv (n : ℕ) :
    SchwartzMap (YmymgJointPoints n) ℂ ≃ₗ[ℂ]
      SchwartzMap (Fin n → Spacetime) ℂ :=
  LinearEquiv.mk (ymymgJointPushforward n).toLinearMap
    (ymymgJointPullback n) (ymymgJointPull_push n) (ymymgJointPush_pull n)

def ymymgJointSchwartzContinuousLinearEquiv (n : ℕ) :
    SchwartzMap (YmymgJointPoints n) ℂ ≃L[ℂ]
      SchwartzMap (Fin n → Spacetime) ℂ :=
  ContinuousLinearEquiv.mk (ymymgJointSchwartzLinearEquiv n)
    (ymymgJointPushforward n).continuous (ymymgJointPullback n).continuous

/-- Transport a continuous source joint Schwartz correlation functional
to the actual target full n-point Schwartz test space. -/
def ymymgJointKernelToTarget (n : ℕ)
    (K : SchwartzMap (YmymgJointPoints n) ℂ →L[ℂ] ℂ) :
    SchwartzMap (Fin n → Spacetime) ℂ →L[ℂ] ℂ :=
  K.comp (ymymgJointPullback n)

/-- The inverse transport, without any restriction to separated points. -/
def ymymgJointKernelToSource (n : ℕ)
    (K : SchwartzMap (Fin n → Spacetime) ℂ →L[ℂ] ℂ) :
    SchwartzMap (YmymgJointPoints n) ℂ →L[ℂ] ℂ :=
  K.comp (ymymgJointPushforward n)

@[simp] theorem ymymgJointKernelSourceTarget (n : ℕ)
    (K : SchwartzMap (YmymgJointPoints n) ℂ →L[ℂ] ℂ) :
    ymymgJointKernelToSource n (ymymgJointKernelToTarget n K) = K := by
  ext f
  change K (ymymgJointPullback n (ymymgJointPushforward n f)) = K f
  rw [ymymgJointPull_push]

@[simp] theorem ymymgJointKernelTargetSource (n : ℕ)
    (K : SchwartzMap (Fin n → Spacetime) ℂ →L[ℂ] ℂ) :
    ymymgJointKernelToTarget n (ymymgJointKernelToSource n K) = K := by
  ext f
  change K (ymymgJointPushforward n (ymymgJointPullback n f)) = K f
  rw [ymymgJointPush_pull]

/-- Product-test evaluations are pointwise invariant under the
source→target coordinate reindexing. This is the exact tensor test
identity needed to match physical n-point vacuum words later. -/
theorem ymymgJointTensorPointwise (n : ℕ)
    (tests : Fin n → SchwartzMap (EuclideanSpace ℝ (Fin 4)) ℂ)
    (x : YmymgJointPoints n) :
    (∏ i : Fin n, (ymymgPushforwardSchwartz (tests i))
      (ymymgJointToTarget n x i)) =
    (∏ i : Fin n, tests i (x i)) := by
  apply Finset.prod_congr rfl
  intro i _
  change tests i (targetToYmymgPoint (ymymgToTargetPoint (x i))) = tests i (x i)
  rw [targetToYmymg_ymymgToTarget]

end YangMills
