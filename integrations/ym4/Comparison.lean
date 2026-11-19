import YangMills.ExistenceOnly
import YangMills.PeriodicLattice4
import Mathlib.LinearAlgebra.UnitaryGroup
import Mathlib.MeasureTheory.Measure.Support
import Mathlib.Probability.Distributions.Gamma

set_option autoImplicit false
set_option warningAsError true

/-!
# Checks for the YM4 manuscript comparison

The finite-lattice check uses the manuscript's exact SU(2) Wilson weight.
The continuum checks concern an already reconstructed Hilbert space and the
spectral example in `YM4_1400.tex`, under “What the reconstructed field establishes”.
See `source/YM4_SOURCE_REVIEW.md` for the source revision and analytic premises.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set YangMills

namespace YM4Audit
universe u

abbrev SU2 := Matrix.specialUnitaryGroup (Fin 2) ℂ

/-- The action density of one plaquette in the defining representation. -/
def plaquetteDensity (U : SU2) : ℝ :=
  1 - (Matrix.trace (U : Matrix (Fin 2) (Fin 2) ℂ)).re / 2

theorem plaquetteDensity_inv (U : SU2) : plaquetteDensity U⁻¹ = plaquetteDensity U := by
  unfold plaquetteDensity
  rw [← Matrix.star_eq_inv, Matrix.specialUnitaryGroup.coe_star,
    Matrix.star_eq_conjTranspose, Matrix.trace_conjTranspose]
  rfl

/-- The nonidentity scalar matrix in the center of SU(2). -/
def minusIdentity : SU2 :=
  ⟨-1, by
    rw [Matrix.mem_specialUnitaryGroup_iff, Matrix.mem_unitaryGroup_iff]
    constructor
    · simp
    · norm_num [Matrix.det_neg]⟩

/-- The defining-representation weight distinguishes the two representatives
of the unit class in the quotient by the center. -/
theorem plaquetteDensity_one_ne_minusIdentity :
    plaquetteDensity 1 ≠ plaquetteDensity minusIdentity := by
  norm_num [plaquetteDensity, minusIdentity, Matrix.trace_one]

/-- Use the trace class function on a native gauge group presented as SU(2). -/
def plaquetteClassWeight {G : CompactSimpleGaugeGroup.{u}} (ρ : G.Carrier ≃* SU2) :
    ConjClasses G.Carrier → ℝ :=
  Quotient.lift (fun g => plaquetteDensity (ρ g)) (by
    intro a b hab
    change IsConj a b at hab
    rcases isConj_iff.mp hab with ⟨c, rfl⟩
    simp only [map_mul, map_inv]
    unfold plaquetteDensity
    have trace_conj (A B : SU2) :
        Matrix.trace ((A * B * A⁻¹ : SU2) : Matrix (Fin 2) (Fin 2) ℂ) =
          Matrix.trace (B : Matrix (Fin 2) (Fin 2) ℂ) := by
      rw [Submonoid.coe_mul, Matrix.trace_mul_comm, ← Submonoid.coe_mul,
        inv_mul_cancel_left]
    rw [trace_conj])

/-- The unnormalized YM4 Wilson weight on the native four-dimensional torus. -/
theorem periodicBoltzmann_eq {G : CompactSimpleGaugeGroup.{u}} (ρ : G.Carrier ≃* SU2)
    (n : ℕ) (β : ℝ) (links : GaugeLinks (PeriodicFourVertex n) G) :
    periodicFourClassBoltzmann n G (plaquetteClassWeight ρ) β links =
      Real.exp (-(β * ((periodicFourPlaquettes n).map fun p =>
        plaquetteDensity (ρ (gaugeHolonomy links p.2))).sum)) := rfl

/-- A nonzero connected pairing in the reconstructed Hilbert space yields
an actual field excitation when those fields are cyclic. -/
theorem hasFieldExcitation_of_connected_pairing {Q : QuantumTheory}
    (axioms : WightmanAxioms Q.State Q.fields) (v w : Q.State)
    (connected : inner ℂ v w ≠
      inner ℂ v (Q.fields.vacuum : Q.State) * inner ℂ (Q.fields.vacuum : Q.State) w) :
    Q.fields.HasFieldExcitation := by
  apply axioms.hasFieldExcitation_iff.mpr
  refine ⟨w, fun hw => connected ?_⟩
  obtain ⟨c, rfl⟩ := Submodule.mem_span_singleton.mp hw
  simp [inner_smul_right, inner_self_eq_norm_sq_to_K, axioms.vacuum_norm, mul_comm]

/-- For a fixed group, the extra spectral requirement is on the Hamiltonian
of the same candidate that supplies the native existence fields. -/
theorem generatedCandidate_iff_same_hamiltonian_gap (G : CompactSimpleGaugeGroup.{u}) :
    Nonempty (FilteredGeneratedCandidate G) ↔
      ∃ c : FilteredExistenceCandidate G, HasPositiveFiniteMass c.theory.fields.hamiltonian.realSpectrum := by
  constructor
  · rintro ⟨c⟩
    exact ⟨c.toExistenceOnly, c.qft_and_gap.massGap⟩
  · rintro ⟨c, gap⟩
    exact ⟨{ c with qft_and_gap := ⟨c.qft_axioms, gap⟩ }⟩

/-- The manuscript's positive energy measure with density E exp(-E) on E > 0. -/
def gaplessMeasure : Measure ℝ := gammaMeasure 2 1

theorem gaplessMeasure_probability : IsProbabilityMeasure gaplessMeasure :=
  isProbabilityMeasure_gammaMeasure (by norm_num) (by norm_num)

private theorem gamma_two : Real.Gamma 2 = 1 := by
  convert Real.Gamma_nat_eq_factorial 1 using 1 <;> norm_num

private theorem gaplessDensity_measurable : Measurable (gammaPDF 2 1) :=
  (measurable_gammaPDFReal 2 1).ennreal_ofReal

/-- In particular there is positive spectral weight arbitrarily close to zero. -/
theorem gaplessMeasure_support : gaplessMeasure.support = Ici 0 := by
  apply Subset.antisymm
  · apply Measure.support_subset_of_isClosed isClosed_Ici
    rw [mem_ae_iff, compl_Ici]
    rw [gaplessMeasure, gammaMeasure, withDensity_apply _ measurableSet_Iio]
    exact lintegral_gammaPDF_of_nonpos le_rfl
  · rw [← closure_Ioi]
    apply closure_minimal _ Measure.isClosed_support
    intro E hE
    rw [Measure.support_eq_forall_isOpen]
    intro U hEU hU
    have hpos : 0 < (volume : Measure ℝ) (U ∩ Ioi 0) :=
      (hU.inter isOpen_Ioi).measure_pos _ ⟨E, hEU, hE⟩
    apply pos_of_ne_zero
    intro hzero
    rw [gaplessMeasure, gammaMeasure, withDensity_apply_eq_zero gaplessDensity_measurable] at hzero
    apply hpos.ne' (measure_mono_null ?_ hzero)
    rintro x ⟨hxU, hx⟩
    have density_pos : 0 < gammaPDFReal 2 1 x :=
      gammaPDFReal_pos (by norm_num) (by norm_num) hx
    exact ⟨by simpa [gammaPDF] using density_pos, hxU⟩

/-- The Laplace transform decays quadratically in Euclidean time. -/
theorem gaplessMeasure_laplace (t : ℝ) (ht : 0 ≤ t) :
    (∫ E, Real.exp (-t * E) ∂gaplessMeasure) = (1 + t)⁻¹ ^ 2 := by
  rw [gaplessMeasure, gammaMeasure,
    integral_withDensity_eq_integral_toReal_smul gaplessDensity_measurable
      (ae_of_all _ fun _ => ENNReal.ofReal_lt_top)]
  have density (E : ℝ) : (gammaPDF 2 1 E).toReal • Real.exp (-t * E) =
      (Ioi (0 : ℝ)).indicator (fun x => x * Real.exp (-((1 + t) * x))) E := by
    rw [gammaPDF, ENNReal.toReal_ofReal (gammaPDFReal_nonneg (by norm_num) (by norm_num) E),
      smul_eq_mul]
    rcases lt_trichotomy E 0 with hneg | rfl | hpos
    · simp [gammaPDFReal, hneg.not_ge, indicator_of_notMem, hneg.not_gt]
    · norm_num [gammaPDFReal, gamma_two]
    · rw [gammaPDFReal, if_pos hpos.le, indicator_of_mem (show E ∈ Ioi (0 : ℝ) from hpos),
        gamma_two]
      simp only [Real.one_rpow, div_one, one_mul, show (2 : ℝ) - 1 = 1 by norm_num,
        Real.rpow_one, mul_assoc, ← Real.exp_add]
      congr 2
      ring
  simp_rw [density]
  rw [integral_indicator measurableSet_Ioi]
  simpa [gamma_two, show (2 : ℝ) - 1 = 1 by norm_num, Real.rpow_natCast, one_div] using
    Real.integral_rpow_mul_exp_neg_mul_Ioi (a := 2) (r := 1 + t) (by norm_num) (by positivity)

/-- Quadratic decay of the Laplace transform allows support at every positive
energy. This counterexample concerns the spectral inference in the audit. -/
theorem gaplessMeasure_no_gap (Δ : ℝ) : ¬ IsMassGap gaplessMeasure.support Δ := by
  rintro ⟨hΔ, hgap⟩
  have energy : Δ / 2 ∈ gaplessMeasure.support := by
    rw [gaplessMeasure_support]
    exact div_nonneg hΔ.le (by norm_num)
  exact hgap (Δ / 2) energy ⟨by positivity, by linarith⟩

end YM4Audit
