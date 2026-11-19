import YMResearch.FixedTimeTransfer
import YangMills.QFT.Operator
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Log.Basic

/-!
# Fixed-time contraction and the native unbounded Hamiltonian

The fixed-time transfer bound is converted to the `ym-lean` resolvent using
the heat evolution of the actual operator on its domain. A real shift below
the proposed gap is bounded below. Self-adjointness gives closed range and
surjectivity, so this proves exclusion from the full spectrum.
-/

noncomputable section
open Filter Set Submodule YangMills
open scoped Topology

namespace YMResearch

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

private def shift (A : DenselyDefinedOperator H) (e : ℝ) : A.domain →ₗ[ℂ] H :=
  A.toLinearMap - (e : ℂ) • A.domain.subtype

private theorem shift_apply (A : DenselyDefinedOperator H) (e : ℝ) (u : A.domain) :
    shift A e u = A.toLinearMap u - (e : ℂ) • (u : H) := rfl

/-- A lower bound on the entire shifted domain of a self-adjoint operator
gives a bounded, everywhere-defined two-sided resolvent. -/
theorem inResolvent_of_lower_bound [CompleteSpace H] (A : DenselyDefinedOperator H)
    (selfAdjoint : A.IsSelfAdjoint)
    (e C : ℝ) (hC : 0 ≤ C)
    (bound : ∀ u : A.domain, ‖(u : H)‖ ≤ C * ‖A.toLinearMap u - (e : ℂ) • (u : H)‖) :
    A.InResolvent (e : ℂ) := by
  let B := shift A e
  have hnorm (u : A.domain) : ‖u‖ ≤ C * ‖B u‖ := bound u
  have injective : Function.Injective B := by
    intro u v huv
    have h := hnorm (u - v)
    rw [map_sub, huv, sub_self, norm_zero, mul_zero, norm_le_zero_iff] at h
    exact sub_eq_zero.mp h
  have closed : IsClosed (B.range : Set H) := by
    apply IsSeqClosed.isClosed
    intro s y hs hy
    choose u hu using hs
    have hlim : Tendsto (fun n => B (u n)) atTop (𝓝 y) := by simpa only [hu] using hy
    have cauchyH : CauchySeq (fun n => (u n : H)) := by
      refine Metric.cauchySeq_iff.mpr fun ε hε => ?_
      have hc : 0 < C + 1 := by positivity
      obtain ⟨N, hN⟩ := Metric.cauchySeq_iff.mp hlim.cauchySeq (ε / (C + 1)) (by positivity)
      refine ⟨N, fun n hn m hm => ?_⟩
      have boundDist : dist (u n : H) (u m : H) ≤ C * dist (B (u n)) (B (u m)) := by
        have h := hnorm (u n - u m)
        change ‖((u n - u m : A.domain) : H)‖ ≤ C * ‖B (u n - u m)‖ at h
        simpa only [dist_eq_norm, Submodule.coe_sub, map_sub] using h
      have small := (lt_div_iff₀ hc).mp (hN n hn m hm)
      nlinarith [dist_nonneg (x := B (u n)) (y := B (u m))]
    obtain ⟨x, hx⟩ := cauchySeq_tendsto_of_complete cauchyH
    have ha : Tendsto (fun n => A.toLinearMap (u n)) atTop (𝓝 (y + (e : ℂ) • x)) := by
      simpa [B, shift_apply] using hlim.add (tendsto_const_nhds.smul hx :
        Tendsto (fun n => (e : ℂ) • (u n : H)) atTop (𝓝 ((e : ℂ) • x)))
    have relation (v : A.domain) : inner ℂ (A.toLinearMap v) x =
        inner ℂ (v : H) (y + (e : ℂ) • x) := by
      have left := (tendsto_const_nhds (x := A.toLinearMap v)).inner (𝕜 := ℂ) hx
      have right := (tendsto_const_nhds (x := (v : H))).inner (𝕜 := ℂ) ha
      have same : (fun n => inner ℂ (A.toLinearMap v) (u n : H)) =
          (fun n => inner ℂ (v : H) (A.toLinearMap (u n))) := by
        funext n
        exact (selfAdjoint (u n : H) (A.toLinearMap (u n))).mpr ⟨(u n).property, rfl⟩ v
      rw [same] at left
      exact tendsto_nhds_unique left right
    obtain ⟨hxDom, hxMap⟩ := (selfAdjoint x (y + (e : ℂ) • x)).mp relation
    exact ⟨⟨x, hxDom⟩, by simp [B, shift_apply, hxMap]⟩
  have surjective : Function.Surjective B := by
    letI : CompleteSpace B.range := closed.completeSpace_coe
    apply LinearMap.range_eq_top.mp
    apply (B.range.orthogonal_eq_bot_iff).mp
    apply le_bot_iff.mp
    intro y hy
    have relation (v : A.domain) : inner ℂ (A.toLinearMap v) y = inner ℂ (v : H) ((e : ℂ) • y) := by
      have h := (B.range.mem_orthogonal y).mp hy (B v) ⟨v, rfl⟩
      rw [show B v = A.toLinearMap v - (e : ℂ) • (v : H) from rfl,
        inner_sub_left, inner_smul_left, sub_eq_zero] at h
      rw [inner_smul_right]
      simpa using h
    obtain ⟨hyDom, hyMap⟩ := (selfAdjoint y ((e : ℂ) • y)).mp relation
    have h := bound ⟨y, hyDom⟩
    simpa [hyMap] using h
  let equiv := LinearEquiv.ofBijective B ⟨injective, surjective⟩
  let inv := (A.domain.subtype.comp equiv.symm.toLinearMap).mkContinuous C (fun y => by
    have h := hnorm (equiv.symm y)
    change ‖equiv.symm y‖ ≤ C * ‖equiv (equiv.symm y)‖ at h
    simpa using h)
  have inDomain (y : H) : inv y ∈ A.domain := (equiv.symm y).property
  refine ⟨inv, inDomain, ?_, ?_⟩
  · intro y
    exact equiv.apply_symm_apply y
  · intro u
    exact congrArg Subtype.val (equiv.symm_apply_apply u)

/-- Heat evolution linked by differentiation to this unbounded operator,
on the physical time interval used in the comparison. -/
structure HeatEvolution (A : DenselyDefinedOperator H) (τ : ℝ) where
  transfer : ℝ → H →L[ℂ] H
  atZero : transfer 0 = ContinuousLinearMap.id ℂ H
  contraction : ∀ t ∈ Icc 0 τ, ∀ v, ‖transfer t v‖ ≤ ‖v‖
  derivative : ∀ (v : A.domain) t, t ∈ Icc 0 τ →
    HasDerivWithinAt (fun s => transfer s (v : H))
      (-(transfer t (A.toLinearMap v))) (Icc 0 τ) t

private theorem scaledHeat_sub_le {A : DenselyDefinedOperator H} {τ e : ℝ}
    (heat : HeatEvolution A τ) (hτ : 0 < τ) (he : 0 < e) (v : A.domain) :
    ‖Real.exp (τ * e) • heat.transfer τ (v : H) - (v : H)‖ ≤
      (τ * Real.exp (τ * e)) * ‖shift A e v‖ := by
  let f (t : ℝ) := Real.exp (t * e) • heat.transfer t (v : H)
  let derivF (t : ℝ) := -(Real.exp (t * e) • heat.transfer t (shift A e v))
  have derivRule (t : ℝ) (ht : t ∈ Icc 0 τ) : HasDerivWithinAt f (derivF t) (Icc 0 τ) t := by
    have hexp : HasDerivAt (fun s : ℝ => Real.exp (s * e)) (Real.exp (t * e) * e) t := by
      simpa only [id_eq, one_mul] using ((hasDerivAt_id t).mul_const e).exp
    have h := hexp.hasDerivWithinAt.smul (heat.derivative v t ht)
    have formula :
        Real.exp (t * e) • (-heat.transfer t (A.toLinearMap v)) +
          (Real.exp (t * e) * e) • heat.transfer t (v : H) = derivF t := by
      have shiftReal : shift A e v = A.toLinearMap v - e • (v : H) := rfl
      have mapReal : heat.transfer t (e • (v : H)) = e • heat.transfer t (v : H) :=
        ((heat.transfer t).restrictScalars ℝ).map_smul e (v : H)
      dsimp [derivF]
      rw [shiftReal, map_sub, mapReal, smul_sub, neg_sub, mul_smul, smul_neg]
      abel
    rw [← formula]
    exact h
  have derivBound (t : ℝ) (ht : t ∈ Ico 0 τ) :
      ‖derivF t‖ ≤ Real.exp (τ * e) * ‖shift A e v‖ := by
    rw [show ‖derivF t‖ = Real.exp (t * e) * ‖heat.transfer t (shift A e v)‖ by
      simp [derivF, norm_smul, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]]
    exact mul_le_mul (Real.exp_le_exp.mpr (mul_le_mul_of_nonneg_right ht.2.le he.le))
      (heat.contraction t (Ico_subset_Icc_self ht) _) (norm_nonneg _) (Real.exp_pos _).le
  have h := norm_image_sub_le_of_norm_deriv_le_segment' derivRule derivBound τ ⟨hτ.le, le_rfl⟩
  simpa [f, heat.atZero, mul_comm, mul_left_comm, mul_assoc] using h

variable [CompleteSpace H]

/-- The heat form is bounded by `exp (-τ * Δ)` on the complement of the
zero-energy sector at one positive physical time. This implies the native
gap for the full real spectrum defined by the unbounded resolvent. -/
theorem isMassGap_of_heatForm {A : DenselyDefinedOperator H} (selfAdjoint : A.IsSelfAdjoint)
    (Z : Submodule ℂ H) [Z.HasOrthogonalProjection]
    (ground : ∀ z : Z, ∃ hz : (z : H) ∈ A.domain, A.toLinearMap ⟨z, hz⟩ = 0)
    {τ Δ : ℝ} (hτ : 0 < τ) (hΔ : 0 < Δ) (heat : HeatEvolution A τ)
    (bound : ∀ v : Zᗮ, (heat.transfer τ).reApplyInnerSelf (v : H) ≤
      Real.exp (-(τ * Δ)) * ‖v‖ ^ 2) : IsMassGap A.realSpectrum Δ := by
  refine ⟨hΔ, ?_⟩
  rintro e hspectrum ⟨he, heΔ⟩
  let c := Real.exp (τ * e)
  let margin := 1 - c * Real.exp (-(τ * Δ))
  have hc : 0 < c := Real.exp_pos _
  have hm : 0 < margin := by
    apply sub_pos.mpr
    rw [show c = Real.exp (τ * e) from rfl, ← Real.exp_add, ← Real.exp_zero]
    exact Real.exp_lt_exp.mpr (by nlinarith [mul_pos hτ (sub_pos.mpr heΔ)])
  let C := (τ * c) / margin
  have hC : 0 ≤ C := by dsimp [C]; positivity
  have excitationBound (v : A.domain) (hv : (v : H) ∈ Zᗮ) :
      ‖(v : H)‖ ≤ C * ‖shift A e v‖ := by
    by_cases hzero : (v : H) = 0
    · rw [hzero, norm_zero]
      positivity
    have hnorm : 0 < ‖(v : H)‖ := norm_pos_iff.mpr hzero
    have hform := bound ⟨v, hv⟩
    change (heat.transfer τ).reApplyInnerSelf (v : H) ≤
      Real.exp (-(τ * Δ)) * ‖(v : H)‖ ^ 2 at hform
    have innerDiff : (inner ℂ ((v : H) - c • heat.transfer τ (v : H)) (v : H)).re =
        ‖(v : H)‖ ^ 2 - c * (heat.transfer τ).reApplyInnerSelf (v : H) := by
      rw [inner_sub_left, inner_smul_left_eq_smul]
      change (inner ℂ (v : H) (v : H) - (c : ℂ) * inner ℂ (heat.transfer τ (v : H)) (v : H)).re = _
      have normSq : (inner ℂ (v : H) (v : H)).re = ‖(v : H)‖ ^ 2 :=
        inner_self_eq_norm_sq (𝕜 := ℂ) (v : H)
      rw [Complex.sub_re, Complex.mul_re, normSq, Complex.ofReal_re, Complex.ofReal_im, zero_mul, sub_zero]
      rfl
    have hre : margin * ‖(v : H)‖ ^ 2 ≤
        (inner ℂ ((v : H) - c • heat.transfer τ (v : H)) (v : H)).re := by
      rw [innerDiff]
      calc
        margin * ‖(v : H)‖ ^ 2 = ‖(v : H)‖ ^ 2 - c * (Real.exp (-(τ * Δ)) * ‖(v : H)‖ ^ 2) := by
          dsimp [margin]
          ring
        _ ≤ _ := sub_le_sub_left (mul_le_mul_of_nonneg_left hform hc.le) _
    have hnormUpper := (Complex.re_le_norm
      (inner ℂ ((v : H) - c • heat.transfer τ (v : H)) (v : H))).trans
      (norm_inner_le_norm _ _)
    have hdiff := scaledHeat_sub_le heat hτ he v
    rw [norm_sub_rev] at hdiff
    have hCancel : margin * ‖(v : H)‖ ≤ τ * c * ‖shift A e v‖ := by
      apply le_of_mul_le_mul_right _ hnorm
      calc
        margin * ‖(v : H)‖ * ‖(v : H)‖ = margin * ‖(v : H)‖ ^ 2 := by ring
        _ ≤ ‖(v : H) - c • heat.transfer τ (v : H)‖ * ‖(v : H)‖ := hre.trans hnormUpper
        _ ≤ (τ * c * ‖shift A e v‖) * ‖(v : H)‖ :=
          mul_le_mul_of_nonneg_right hdiff hnorm.le
    calc
      ‖(v : H)‖ ≤ τ * c * ‖shift A e v‖ / margin := (le_div_iff₀ hm).mpr (by simpa [mul_comm] using hCancel)
      _ = C * ‖shift A e v‖ := by simp [C, div_mul_eq_mul_div]
  have imageOrth (v : A.domain) : A.toLinearMap v ∈ Zᗮ := by
    apply (Z.mem_orthogonal _).mpr
    intro z hz
    obtain ⟨zDom, zZero⟩ := ground ⟨z, hz⟩
    have hzAdj := (selfAdjoint z 0).mpr ⟨zDom, zZero⟩ v
    rw [inner_zero_right] at hzAdj
    rw [← inner_conj_symm z (A.toLinearMap v), hzAdj, map_zero]
  apply hspectrum
  apply inResolvent_of_lower_bound A selfAdjoint e (e⁻¹ + C) (by positivity)
  intro u
  let p : Z := Z.orthogonalProjectionOnto (u : H)
  obtain ⟨pDom, pZero⟩ := ground p
  let u0 : A.domain := ⟨p, pDom⟩
  let u1 := u - u0
  have hu1 : (u1 : H) ∈ Zᗮ := Z.sub_starProjection_mem_orthogonal (u : H)
  have split : u0 + u1 = u := by simp [u1]
  have hShift0 : shift A e u0 = -((e : ℂ) • (u0 : H)) := by simp [shift_apply, u0, pZero]
  have h0 : shift A e u0 ∈ Z := by
    rw [hShift0]
    exact Z.neg_mem (Z.smul_mem _ p.property)
  have h1 : shift A e u1 ∈ Zᗮ :=
    Zᗮ.sub_mem (imageOrth u1) (Zᗮ.smul_mem _ hu1)
  have hsum : shift A e u0 + shift A e u1 = shift A e u := by rw [← map_add, split]
  have hsquares : ‖shift A e u‖ ^ 2 = ‖shift A e u0‖ ^ 2 + ‖shift A e u1‖ ^ 2 := by
    rw [← hsum, sq, sq, sq]
    exact norm_add_sq_eq_norm_sq_add_norm_sq_of_inner_eq_zero _ _ ((Z.mem_orthogonal _).mp h1 _ h0)
  have hBound0 : ‖shift A e u0‖ ≤ ‖shift A e u‖ := by
    apply (sq_le_sq₀ (norm_nonneg _) (norm_nonneg _)).mp
    rw [hsquares]
    exact le_add_of_nonneg_right (sq_nonneg _)
  have hBound1 : ‖shift A e u1‖ ≤ ‖shift A e u‖ := by
    apply (sq_le_sq₀ (norm_nonneg _) (norm_nonneg _)).mp
    rw [hsquares]
    exact le_add_of_nonneg_left (sq_nonneg _)
  have hnorm0 : ‖(u0 : H)‖ ≤ e⁻¹ * ‖shift A e u‖ := by
    rw [hShift0, norm_neg, norm_smul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos he] at hBound0
    rw [← div_eq_inv_mul]
    exact (le_div_iff₀ he).mpr (by simpa [mul_comm] using hBound0)
  have hnorm1 := (excitationBound u1 hu1).trans (mul_le_mul_of_nonneg_left hBound1 hC)
  change ‖(u : H)‖ ≤ (e⁻¹ + C) * ‖shift A e u‖
  calc
    ‖(u : H)‖ ≤ ‖(u0 : H)‖ + ‖(u1 : H)‖ := by
      rw [← split]
      exact norm_add_le _ _
    _ ≤ (e⁻¹ + C) * ‖shift A e u‖ := by rw [add_mul]; exact add_le_add hnorm0 hnorm1

/-- Recover a gap of size `-log R / τ` from the cutoff Gram data, the form
at physical time `τ`, and the full stationary plateau. The generator is the
same operator whose heat form occurs in the limit. -/
theorem isMassGap_of_plateauLimits {A : DenselyDefinedOperator H} (selfAdjoint : A.IsSelfAdjoint)
    (Z : Submodule ℂ H) [Z.HasOrthogonalProjection]
    (ground : ∀ z : Z, ∃ hz : (z : H) ∈ A.domain, A.toLinearMap ⟨z, hz⟩ = 0)
    {τ R : ℝ} (hτ : 0 < τ) (hR : 0 < R) (strict : R < 1) (heat : HeatEvolution A τ)
    (symmetric : (heat.transfer τ).toLinearMap.IsSymmetric)
    (fixed : ∀ z ∈ Z, heat.transfer τ z = z)
    {ι V : Type*} {l : Filter ι} [l.NeBot]
    (word : V → H) (dense : DenseRange word) (gram atTime plateau : ι → V → ℝ)
    (hgram : ∀ f, Tendsto (fun i => gram i f) l (𝓝 (‖word f‖ ^ 2)))
    (htime : ∀ f, Tendsto (fun i => atTime i f) l (𝓝 ((heat.transfer τ).reApplyInnerSelf (word f))))
    (hplateau : ∀ f, Tendsto (fun i => plateau i f) l (𝓝 (‖Z.starProjection (word f)‖ ^ 2)))
    (hbound : ∀ f, ∀ᶠ i in l, atTime i f - plateau i f ≤ R * (gram i f - plateau i f)) :
    IsMassGap A.realSpectrum (-Real.log R / τ) := by
  apply isMassGap_of_heatForm selfAdjoint Z ground hτ (div_pos (neg_pos.mpr (Real.log_neg hR strict)) hτ) heat
  have rate : -(τ * (-Real.log R / τ)) = Real.log R := by field_simp
  rw [rate, Real.exp_log hR]
  exact fixedTimeBound_of_plateauLimits Z (heat.transfer τ) R symmetric fixed word dense
    gram atTime plateau hgram htime hplateau hbound

end YMResearch
