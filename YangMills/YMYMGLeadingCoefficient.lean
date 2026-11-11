import YangMills.Renormalization

set_option backward.isDefEq.respectTransparency false
set_option warningAsError true

/-!
# Leading Yang–Mills beta/trace normalization cross-check

The October YM-ymg submission defines
  b0(G) = 11 * G.casimir / (48 * pi^2)
  slopeConstant(G) = 11 * G.casimir / (24 * pi^2)
  d2(G) = -b0(G)/2
  award(G) = 12*(d2(G)^2/b0(G)^2) * lieDim(G)/pi^4.

This file compares those explicit scalar formulas with ym-lean's
Perturbative.betaTwoLoop, provided the two actual adjoint Casimirs are
identified. It does NOT show that the generated nonperturbative beta jet
or physical two-point correlator equals this conventional coefficient,
nor identify the two different groups' Lie-algebra normalizations.
-/

noncomputable section
namespace YangMills

/-- October's conventional first beta coefficient for an adjoint Casimir. -/
def ymymgOneLoopB0 (cA : ℝ) : ℝ :=
  11 * cA / (48 * Real.pi ^ 2)

/-- October's corresponding Wilson inverse-action logarithmic slope. -/
def ymymgWilsonSlope (cA : ℝ) : ℝ :=
  11 * cA / (24 * Real.pi ^ 2)

theorem ymymgWilsonSlope_eq_twice_b0 (cA : ℝ) :
    ymymgWilsonSlope cA = 2 * ymymgOneLoopB0 cA := by
  unfold ymymgWilsonSlope ymymgOneLoopB0
  ring

/-- With identical adjoint-Casimir normalization, ym-lean's explicitly
written two-loop polynomial has the *same* first beta coefficient as
the October YM-ymg b0. This is algebraic equality of conventional
coefficients, not a theorem of physical all-orders matching. -/
theorem betaTwoLoop_eq_ymymg_first_coefficient
    {G : CompactSimpleGaugeGroup} {B : InvariantForm G}
    (e : Perturbative.ColorFrame B) (g : ℝ) :
    Perturbative.betaTwoLoop e g =
      -(ymymgOneLoopB0 (Perturbative.adjointCasimir e)) * g ^ 3 -
      ((34 / 3 : ℝ) * (Perturbative.adjointCasimir e) ^ 2 /
         (4 * Real.pi) ^ 4) * g ^ 5 := by
  unfold Perturbative.betaTwoLoop ymymgOneLoopB0
  ring

def ymymgTraceD2 (cA : ℝ) : ℝ :=
  -ymymgOneLoopB0 cA / 2

/-- Source formula for the leading centered-stress-trace coefficient. -/
def ymymgLeadingTraceAward (cA : ℝ) (dim : ℕ) : ℝ :=
  12 * (ymymgTraceD2 cA ^ 2 / ymymgOneLoopB0 cA ^ 2) *
    (dim : ℝ) / Real.pi ^ 4

theorem ymymgOneLoopB0_ne_zero {cA : ℝ} (h : cA ≠ 0) :
    ymymgOneLoopB0 cA ≠ 0 := by
  unfold ymymgOneLoopB0
  exact div_ne_zero (mul_ne_zero (by norm_num) h)
    (mul_ne_zero (by norm_num) (pow_ne_zero _ Real.pi_ne_zero))

/-- The source's algebraic trace coefficient simplifies to
3 dim(g)/pi^4 whenever the Casimir is nonzero. This equality itself
does NOT derive a physical trace two-point function from ym-lean's
generated perturbative sector. -/
theorem ymymgLeadingTraceAward_eq
    (cA : ℝ) (dim : ℕ) (h : cA ≠ 0) :
    ymymgLeadingTraceAward cA dim =
      3 * (dim : ℝ) / Real.pi ^ 4 := by
  have hb := ymymgOneLoopB0_ne_zero h
  unfold ymymgLeadingTraceAward ymymgTraceD2
  field_simp [hb, Real.pi_ne_zero]
  ring

end YangMills
