import Mathlib.Analysis.InnerProductSpace.Projection.Submodule
import Mathlib.Analysis.InnerProductSpace.Symmetric

/-!
# Fixed-time recovery on the full excitation space

This formalizes the recovery inequalities of `alxwest/ym` R202609218003,
R202609218013, R202609218025 and R202609218026. The regulator index can be any
nontrivial filter. The input consists of norms and one-time matrix elements
of the actual approximants, so their Hilbert spaces can change with the cutoff.
-/

noncomputable section
open Filter Submodule
open scoped Topology

namespace YMResearch

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- The real form at fixed time after removing the whole fixed subspace. -/
theorem projectedForm_eq (Z : Submodule ℂ H) [Z.HasOrthogonalProjection]
    (T : H →L[ℂ] H) (symmetric : T.toLinearMap.IsSymmetric)
    (fixed : ∀ z ∈ Z, T z = z) (v : H) :
    T.reApplyInnerSelf (Zᗮ.starProjection v) =
      T.reApplyInnerSelf v - ‖Z.starProjection v‖ ^ 2 := by
  let z := Z.starProjection v
  let w := Zᗮ.starProjection v
  have hz : z ∈ Z := (Z.orthogonalProjectionOnto v).property
  have hw : w ∈ Zᗮ := (Zᗮ.orthogonalProjectionOnto v).property
  have split : z + w = v := Z.starProjection_add_starProjection_orthogonal v
  have orth : inner ℂ z w = 0 := (Z.mem_orthogonal w).mp hw z hz
  have other : inner ℂ (T w) z = 0 := by
    calc
      inner ℂ (T w) z = inner ℂ w (T z) := symmetric w z
      _ = 0 := by rw [fixed z hz, ← inner_conj_symm w z, orth, map_zero]
  calc
    T.reApplyInnerSelf w = T.reApplyInnerSelf (z + w) - ‖z‖ ^ 2 := by
      simp only [ContinuousLinearMap.reApplyInnerSelf_apply, map_add, inner_add_left,
        inner_add_right, fixed z hz, orth, other, add_zero, zero_add,
        inner_self_eq_norm_sq]
      ring
    _ = T.reApplyInnerSelf v - ‖z‖ ^ 2 := by rw [split]

/-- Eventual cutoff inequalities pass to the entire excitation space.
The continuum form can be recovered by a lower bound up to each error
tolerance. The recovered vectors include a dense set of linear combinations. -/
theorem fixedTimeBound_of_projectedRecovery {ι V : Type*} {l : Filter ι} [l.NeBot]
    (Z : Submodule ℂ H) (T : H →L[ℂ] H) (R : ℝ)
    (recover : V → Zᗮ) (dense : DenseRange recover)
    (normSq form : ι → V → ℝ)
    (hnorm : ∀ f, Tendsto (fun i => normSq i f) l (𝓝 (‖recover f‖ ^ 2)))
    (hform : ∀ f ε, 0 < ε →
      ∀ᶠ i in l, T.reApplyInnerSelf (recover f : H) - ε ≤ form i f)
    (hbound : ∀ f, ∀ᶠ i in l, form i f ≤ R * normSq i f) :
    ∀ v : Zᗮ, T.reApplyInnerSelf (v : H) ≤ R * ‖v‖ ^ 2 := by
  have closed : IsClosed {v : Zᗮ | T.reApplyInnerSelf (v : H) ≤ R * ‖v‖ ^ 2} :=
    isClosed_le (T.reApplyInnerSelf_continuous.comp continuous_subtype_val)
      (continuous_const.mul (continuous_norm.pow 2))
  have onRange : Set.range recover ⊆ {v : Zᗮ | T.reApplyInnerSelf (v : H) ≤ R * ‖v‖ ^ 2} := by
    rintro _ ⟨f, rfl⟩
    change T.reApplyInnerSelf (recover f : H) ≤ R * ‖recover f‖ ^ 2
    refine le_of_forall_pos_le_add fun ε hε => ?_
    have h : T.reApplyInnerSelf (recover f : H) - ε ≤ R * ‖recover f‖ ^ 2 := by
      apply ge_of_tendsto ((tendsto_const_nhds (x := R)).mul (hnorm f))
      filter_upwards [hform f ε hε, hbound f] with i lower upper using lower.trans upper
    exact sub_le_iff_le_add.mp h
  exact fun v => closed.closure_subset_iff.mpr onRange (dense v)

/-- Convergence of the one-time form gives the required lower recovery. -/
theorem fixedTimeBound_of_projectedLimits {ι V : Type*} {l : Filter ι} [l.NeBot]
    (Z : Submodule ℂ H) (T : H →L[ℂ] H) (R : ℝ)
    (recover : V → Zᗮ) (dense : DenseRange recover)
    (normSq form : ι → V → ℝ)
    (hnorm : ∀ f, Tendsto (fun i => normSq i f) l (𝓝 (‖recover f‖ ^ 2)))
    (hform : ∀ f, Tendsto (fun i => form i f) l (𝓝 (T.reApplyInnerSelf (recover f : H))))
    (hbound : ∀ f, ∀ᶠ i in l, form i f ≤ R * normSq i f) :
    ∀ v : Zᗮ, T.reApplyInnerSelf (v : H) ≤ R * ‖v‖ ^ 2 := by
  apply fixedTimeBound_of_projectedRecovery Z T R recover dense normSq form hnorm ?_ hbound
  intro f ε hε
  exact ((tendsto_order.mp (hform f)).1 _ (sub_lt_self _ hε)).mono fun _ h => h.le

/-- Recover the projected forms from the raw Gram form, the fixed-time form
and the full zero-energy plateau. In the rank-one case the plateau is the
squared vacuum overlap. The same proof applies to mixed phase plateaus. -/
theorem fixedTimeBound_of_plateauLimits {ι V : Type*} {l : Filter ι} [l.NeBot]
    (Z : Submodule ℂ H) [Z.HasOrthogonalProjection] (T : H →L[ℂ] H) (R : ℝ)
    (symmetric : T.toLinearMap.IsSymmetric) (fixed : ∀ z ∈ Z, T z = z)
    (word : V → H) (dense : DenseRange word) (gram atTime plateau : ι → V → ℝ)
    (hgram : ∀ f, Tendsto (fun i => gram i f) l (𝓝 (‖word f‖ ^ 2)))
    (htime : ∀ f, Tendsto (fun i => atTime i f) l (𝓝 (T.reApplyInnerSelf (word f))))
    (hplateau : ∀ f, Tendsto (fun i => plateau i f) l (𝓝 (‖Z.starProjection (word f)‖ ^ 2)))
    (hbound : ∀ f, ∀ᶠ i in l, atTime i f - plateau i f ≤ R * (gram i f - plateau i f)) :
    ∀ v : Zᗮ, T.reApplyInnerSelf (v : H) ≤ R * ‖v‖ ^ 2 := by
  let recover := Zᗮ.orthogonalProjectionOnto ∘ word
  have onto : Function.Surjective Zᗮ.orthogonalProjectionOnto :=
    fun v => ⟨v, Zᗮ.orthogonalProjectionOnto_mem_subspace_eq_self v⟩
  have recoverDense : DenseRange recover :=
    onto.denseRange.comp dense Zᗮ.orthogonalProjectionOnto.continuous
  apply fixedTimeBound_of_projectedLimits Z T R recover recoverDense
    (fun i f => gram i f - plateau i f) (fun i f => atTime i f - plateau i f) ?_ ?_ hbound
  · intro f
    have normEq : ‖word f‖ ^ 2 - ‖Z.starProjection (word f)‖ ^ 2 = ‖recover f‖ ^ 2 :=
      sub_eq_of_eq_add' (Z.norm_sq_eq_add_norm_sq_starProjection (word f))
    exact normEq ▸ (hgram f).sub (hplateau f)
  · intro f
    rw [show (recover f : H) = Zᗮ.starProjection (word f) from rfl,
      projectedForm_eq Z T symmetric fixed]
    exact (htime f).sub (hplateau f)

end YMResearch
