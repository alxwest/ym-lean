import YangMills.QFT.Operator
import Mathlib.Analysis.InnerProductSpace.Orthogonal
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.MeasureTheory.Integral.Bochner.Set
import Mathlib.MeasureTheory.Measure.Support

/-!
# The common Euclidean decay rate criterion

The spectral-projection argument in `alxwest/ym` R202609218019. The
scalar spectral measures, bounded spectral projections and their relation
to the particular Hamiltonian's spectrum are inputs to the application.
-/

noncomputable section
open Filter MeasureTheory Set Submodule YangMills
open scoped Topology ENNReal

namespace YMResearch

/-- A common exponential upper bound kills all the spectral mass below any
strictly smaller energy. Integrability prevents a totalized Bochner integral
from satisfying the estimate without a spectral interpretation. -/
theorem measure_Iio_eq_zero_of_laplace_decay (μ : Measure ℝ) [IsFiniteMeasure μ]
    {Δ b C : ℝ} (hb : b < Δ)
    (decay : ∀ᶠ t : ℝ in atTop,
      Integrable (fun e => Real.exp (-(t * e))) μ ∧
        (∫ e, Real.exp (-(t * e)) ∂μ) ≤ C * Real.exp (-(t * Δ))) : μ (Iio b) = 0 := by
  have bound : ∀ᶠ t : ℝ in atTop, μ.real (Iio b) ≤ C * Real.exp ((b - Δ) * t) := by
    filter_upwards [decay, eventually_ge_atTop (0 : ℝ)] with t ht ht0
    let c := Real.exp (-(t * b))
    have lower : μ.real (Iio b) * c ≤ ∫ e, Real.exp (-(t * e)) ∂μ := by
      have h := integral_mono ((integrable_const c).indicator measurableSet_Iio) ht.1 (fun e => by
        by_cases he : e ∈ Iio b
        · rw [indicator_of_mem he]
          exact Real.exp_le_exp.mpr (by
            exact neg_le_neg (mul_le_mul_of_nonneg_left (mem_Iio.mp he).le ht0))
        · rw [indicator_of_notMem he]
          positivity)
      rwa [integral_indicator measurableSet_Iio, setIntegral_const, smul_eq_mul] at h
    calc
      μ.real (Iio b) ≤ (C * Real.exp (-(t * Δ))) / c :=
        (le_div_iff₀ (Real.exp_pos _)).mpr (lower.trans ht.2)
      _ = C * Real.exp ((b - Δ) * t) := by
        rw [mul_div_assoc, show c = Real.exp (-(t * b)) from rfl, ← Real.exp_sub]
        congr 2
        ring
  have expLimit : Tendsto (fun t : ℝ => Real.exp ((b - Δ) * t)) atTop (𝓝 0) :=
    Real.tendsto_exp_atBot.comp ((tendsto_const_mul_atBot_of_neg (sub_neg.mpr hb)).mpr tendsto_id)
  have hzero : μ.real (Iio b) ≤ 0 := by
    exact le_of_tendsto_of_tendsto tendsto_const_nhds
      (by simpa using tendsto_const_nhds.mul expLimit) bound
  exact (measureReal_eq_zero_iff (by finiteness)).mp (le_antisymm hzero measureReal_nonneg)

variable {H : Type*} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- Vanishing of the low-energy projections on a dense set excludes that
band from the real spectrum of the supplied native Hamiltonian. -/
theorem isMassGap_of_commonDecay (A : DenselyDefinedOperator H) (Z : Submodule ℂ H)
    {V : Type*} (word : V → Zᗮ) (dense : DenseRange word)
    (spectralMeasure : Zᗮ → Measure ℝ) (finite : ∀ v, IsFiniteMeasure (spectralMeasure v))
    (bandProjection : ℝ → (Zᗮ →L[ℂ] Zᗮ))
    (bandMass : ∀ b v, spectralMeasure v (Iio b) = ENNReal.ofReal (‖bandProjection b v‖ ^ 2))
    (detectsSpectrum : ∀ e ∈ A.realSpectrum, 0 < e → ∀ b, e < b → bandProjection b ≠ 0)
    {Δ : ℝ} (hΔ : 0 < Δ)
    (decay : ∀ f, ∃ C : ℝ, ∀ᶠ t : ℝ in atTop,
      Integrable (fun e => Real.exp (-(t * e))) (spectralMeasure (word f)) ∧
        (∫ e, Real.exp (-(t * e)) ∂spectralMeasure (word f)) ≤ C * Real.exp (-(t * Δ))) :
    IsMassGap A.realSpectrum Δ := by
  refine ⟨hΔ, ?_⟩
  rintro e he ⟨he0, heΔ⟩
  obtain ⟨b, heb, hbΔ⟩ := exists_between heΔ
  apply detectsSpectrum e he he0 b heb
  have closed : IsClosed {v | bandProjection b v = 0} :=
    isClosed_eq (bandProjection b).continuous continuous_const
  have subset : range word ⊆ {v | bandProjection b v = 0} := by
    rintro _ ⟨f, rfl⟩
    letI : IsFiniteMeasure (spectralMeasure (word f)) := finite (word f)
    obtain ⟨_, hdecay⟩ := decay f
    have hzero := measure_Iio_eq_zero_of_laplace_decay (spectralMeasure (word f)) hbΔ hdecay
    rw [bandMass] at hzero
    exact norm_eq_zero.mp (by nlinarith [ENNReal.ofReal_eq_zero.mp hzero, norm_nonneg (bandProjection b (word f))])
  apply ContinuousLinearMap.ext
  intro v
  exact closed.closure_subset_iff.mpr subset (dense v)

/-- A scalar excitation measure with positive mass above zero supplies a
positive spectral value for the native finite-mass clause. -/
theorem positive_spectral_value_of_measure (A : DenselyDefinedOperator H) (μ : Measure ℝ)
    (supported : μ.support ⊆ A.realSpectrum) (nonzero : 0 < μ (Ioi 0)) :
    ∃ e ∈ A.realSpectrum, 0 < e := by
  obtain ⟨e, he, heSupport⟩ := μ.nonempty_inter_support_of_pos nonzero
  exact ⟨e, supported heSupport, he⟩

theorem hasPositiveFiniteMass_of_gap_and_measure (A : DenselyDefinedOperator H)
    {Δ : ℝ} (gap : IsMassGap A.realSpectrum Δ) (μ : Measure ℝ)
    (supported : μ.support ⊆ A.realSpectrum) (nonzero : 0 < μ (Ioi 0)) :
    HasPositiveFiniteMass A.realSpectrum :=
  (hasPositiveFiniteMass_iff _).mpr ⟨⟨Δ, gap⟩, positive_spectral_value_of_measure A μ supported nonzero⟩

end YMResearch
