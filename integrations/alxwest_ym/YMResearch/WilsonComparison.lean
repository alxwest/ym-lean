import Mathlib.MeasureTheory.VectorMeasure.Integral
import Mathlib.Probability.Kernel.Composition.IntegralCompProd

/-!
# Averaging conditional errors for joint Wilson observables

The exterior-averaging step used in the Wilson comparison in `alxwest/ym`
applies to a joint image law, for example the pair of affine plaquette
curvatures in YM4. The kernels below are the two joint laws at fixed exterior.
-/

noncomputable section
open MeasureTheory ProbabilityTheory Set
open scoped MeasureTheory

namespace YMResearch

variable {α β : Type*} [MeasurableSpace α] [MeasurableSpace β]

/-- The full variation mass of the difference of two probability laws.
This is twice the total variation distance in the probability convention. -/
def variationMass (μ ν : Measure β) [IsFiniteMeasure μ] [IsFiniteMeasure ν] : ℝ :=
  (μ.toSignedMeasure - ν.toSignedMeasure).variation.real univ

/-- Apply a variation bound directly to a bounded observable of the entire
joint readout. In particular the observable may depend on both plaquettes. -/
theorem observable_error_le_variation (μ ν : Measure β) [IsFiniteMeasure μ] [IsFiniteMeasure ν]
    {f : β → ℝ} (hf : Measurable f) {M : ℝ} (hM : ∀ b, ‖f b‖ ≤ M) :
    ‖(∫ b, f b ∂μ) - ∫ b, f b ∂ν‖ ≤ M * variationMass μ ν := by
  let σ := μ.toSignedMeasure - ν.toSignedMeasure
  have hσ : σ.variation ≤ μ + ν := by
    simpa [σ] using VectorMeasure.variation_sub_le
      (μ := μ.toSignedMeasure) (ν := ν.toSignedMeasure)
  letI : IsFiniteMeasure σ.variation := isFiniteMeasure_of_le (μ + ν) hσ
  have hμ : μ.toSignedMeasure.Integrable f := by
    change Integrable f μ.toSignedMeasure.variation
    rw [Measure.variation_toSignedMeasure]
    exact Integrable.of_bound hf.aestronglyMeasurable M (ae_of_all _ hM)
  have hν : ν.toSignedMeasure.Integrable f := by
    change Integrable f ν.toSignedMeasure.variation
    rw [Measure.variation_toSignedMeasure]
    exact Integrable.of_bound hf.aestronglyMeasurable M (ae_of_all _ hM)
  have diff : (∫ᵛ b, f b ∂<•σ) = (∫ b, f b ∂μ) - (∫ b, f b ∂ν) := by
    dsimp [σ]
    rw [VectorMeasure.integral_sub_vectorMeasure hμ hν]
    simp
  have normPair : ‖(ContinuousLinearMap.lsmul ℝ ℝ (E := ℝ)).flip‖ ≤ 1 := by
    rw [ContinuousLinearMap.opNorm_flip]
    exact ContinuousLinearMap.opNorm_lsmul_le
  have hnorm : 0 ≤ ∫ b, ‖f b‖ ∂σ.variation := integral_nonneg (fun _ => norm_nonneg _)
  rw [← diff]
  calc
    ‖∫ᵛ b, f b ∂<•σ‖ ≤ ‖(ContinuousLinearMap.lsmul ℝ ℝ (E := ℝ)).flip‖ *
        ∫ b, ‖f b‖ ∂σ.variation := VectorMeasure.norm_integral_le_integral_norm
    _ ≤ ∫ b, ‖f b‖ ∂σ.variation := by
      simpa only [one_mul] using mul_le_mul_of_nonneg_right normPair hnorm
    _ = ‖∫ b, ‖f b‖ ∂σ.variation‖ := (Real.norm_of_nonneg hnorm).symm
    _ ≤ M * variationMass μ ν :=
      norm_integral_le_of_norm_le_const (μ := σ.variation)
        (ae_of_all _ (fun b => (norm_norm (f b)).trans_le (hM b)))

private theorem variationMass_le_two (μ ν : Measure β) [IsProbabilityMeasure μ]
    [IsProbabilityMeasure ν] : variationMass μ ν ≤ 2 := by
  have h : (μ.toSignedMeasure - ν.toSignedMeasure).variation ≤ μ + ν := by
    simpa using VectorMeasure.variation_sub_le (μ := μ.toSignedMeasure) (ν := ν.toSignedMeasure)
  unfold variationMass Measure.real
  exact (ENNReal.toReal_mono (by finiteness) (h univ)).trans_eq (by norm_num [Measure.add_apply])

variable (exterior : Measure α) [IsProbabilityMeasure exterior]
  (actual reference : Kernel α β) [IsMarkovKernel actual] [IsMarkovKernel reference]

private theorem integral_mixture (κ : Kernel α β) [IsMarkovKernel κ]
    {f : β → ℝ} (hf : Measurable f) {M : ℝ} (hM : ∀ b, ‖f b‖ ≤ M) :
    (∫ b, f b ∂(κ ∘ₘ exterior)) = ∫ a, ∫ b, f b ∂κ a ∂exterior := by
  have h : Integrable (fun p : α × β => f p.2) (exterior ⊗ₘ κ) :=
    Integrable.of_bound (hf.comp measurable_snd).aestronglyMeasurable M (ae_of_all _ fun p => hM p.2)
  rw [← Measure.snd_compProd, Measure.snd, integral_map measurable_snd.aemeasurable
    hf.aestronglyMeasurable]
  exact Measure.integral_compProd h

/-- Average the pair-law comparison using the original exterior law.
The integrable envelope bounds the full variation mass almost everywhere. -/
theorem averaged_jointObservable_error {f : β → ℝ} (hf : Measurable f)
    {M : ℝ} (hM : 0 ≤ M) (bounded : ∀ b, ‖f b‖ ≤ M) {ε : α → ℝ}
    (hε : Integrable ε exterior)
    (bound : ∀ᵐ a ∂exterior, variationMass (actual a) (reference a) ≤ ε a) :
    ‖(∫ b, f b ∂(actual ∘ₘ exterior)) - ∫ b, f b ∂(reference ∘ₘ exterior)‖ ≤
      M * ∫ a, ε a ∂exterior := by
  have integrableMean (κ : Kernel α β) [IsMarkovKernel κ] :
      Integrable (fun a => ∫ b, f b ∂κ a) exterior := by
    apply Integrable.of_bound hf.stronglyMeasurable.integral_kernel.aestronglyMeasurable M
    exact ae_of_all _ fun a => by
      simpa using norm_integral_le_of_norm_le_const (μ := κ a) (ae_of_all _ bounded)
  rw [integral_mixture exterior actual hf bounded, integral_mixture exterior reference hf bounded,
    ← integral_sub (integrableMean actual) (integrableMean reference), ← integral_const_mul]
  apply norm_integral_le_of_norm_le (hε.const_mul M)
  filter_upwards [bound] with a ha
  exact (observable_error_le_variation (actual a) (reference a) hf bounded).trans
    (mul_le_mul_of_nonneg_left ha hM)

/-- A bound on good exteriors suffices with an additional error proportional
to the probability of their complement under the same exterior law. -/
theorem jointObservable_error_of_goodExterior {f : β → ℝ} (hf : Measurable f)
    {M : ℝ} (hM : 0 ≤ M) (bounded : ∀ b, ‖f b‖ ≤ M) {good : Set α}
    (hgood : MeasurableSet good) {ε : α → ℝ} (hε : IntegrableOn ε good exterior)
    (bound : ∀ᵐ a ∂exterior.restrict good, variationMass (actual a) (reference a) ≤ ε a) :
    ‖(∫ b, f b ∂(actual ∘ₘ exterior)) - ∫ b, f b ∂(reference ∘ₘ exterior)‖ ≤
      M * ((∫ a in good, ε a ∂exterior) + 2 * exterior.real goodᶜ) := by
  classical
  let envelope := good.piecewise ε (fun _ => 2)
  have hBad : IntegrableOn (fun _ : α => (2 : ℝ)) goodᶜ exterior :=
    (integrable_const 2).integrableOn
  have hEnv : Integrable envelope exterior := Integrable.piecewise hgood hε hBad
  have whole : ∀ᵐ a ∂exterior, variationMass (actual a) (reference a) ≤ envelope a := by
    filter_upwards [(ae_restrict_iff' hgood).mp bound] with a ha
    by_cases haGood : a ∈ good
    · simpa [envelope, haGood] using ha haGood
    · simpa [envelope, haGood] using variationMass_le_two (actual a) (reference a)
  have h := averaged_jointObservable_error exterior actual reference hf hM bounded hEnv whole
  simpa [envelope, integral_piecewise hgood hε hBad, smul_eq_mul, mul_comm] using h

end YMResearch
