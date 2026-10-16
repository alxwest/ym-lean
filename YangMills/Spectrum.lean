import Mathlib.Data.Real.CompleteField
import Mathlib.Order.Bounds.Basic

/-!
# The spectral clause in Jaffe–Witten, §4

Here `σ` is intended to be the **full real spectrum** of the self-adjoint
Hamiltonian, including continuous spectrum, not just its eigenvalues.
The link to an actual Hamiltonian is an obligation of `Framework`.
-/

namespace YangMills

/-- Positive energy: there is no spectrum below zero. -/
def PositiveEnergy (σ : Set ℝ) : Prop :=
  ∀ E ∈ σ, 0 ≤ E

/-- A positive number Δ is a gap when the open interval (0, Δ) misses σ.
The endpoint Δ is allowed in σ; we do not demand a one-particle eigenstate. -/
def IsMassGap (σ : Set ℝ) (Δ : ℝ) : Prop :=
  0 < Δ ∧ ∀ E ∈ σ, ¬ (0 < E ∧ E < Δ)

/-- The admissible positive gaps, whose supremum is the physical mass. -/
def admissibleGaps (σ : Set ℝ) : Set ℝ := {Δ | IsMassGap σ Δ}

/-- This expression represents the mass only when `admissibleGaps σ` is
nonempty and bounded above. Lean's real supremum is total, so those hypotheses
must not be omitted; see `HasPositiveFiniteMass`. -/
noncomputable def mass (σ : Set ℝ) : ℝ := sSup (admissibleGaps σ)

/-- The two requirements in §4: a positive gap exists and its supremum is finite.
Boundedness is essential: σ = {0} has arbitrarily large gaps and is excluded. -/
def HasPositiveFiniteMass (σ : Set ℝ) : Prop :=
  (∃ Δ : ℝ, IsMassGap σ Δ) ∧ BddAbove (admissibleGaps σ)

/-- Under the stated hypotheses the supremum really is strictly positive. -/
theorem mass_pos (σ : Set ℝ) (h : HasPositiveFiniteMass σ) :
    0 < mass σ := by
  obtain ⟨⟨Δ, hΔ⟩, hbounded⟩ := h
  exact lt_of_lt_of_le hΔ.1 (le_csSup hbounded hΔ)

/-- The interval formulation also says every nonzero spectral energy is at
least Δ, provided the positive-energy condition holds. -/
theorem isMassGap_iff (σ : Set ℝ) (hpos : PositiveEnergy σ) (Δ : ℝ) :
    IsMassGap σ Δ ↔ 0 < Δ ∧ ∀ E ∈ σ, E = 0 ∨ Δ ≤ E := by
  constructor
  · rintro ⟨hΔ, hgap⟩
    refine ⟨hΔ, ?_⟩
    intro E hE
    by_cases hzero : E = 0
    · exact Or.inl hzero
    · exact Or.inr (le_of_not_gt (fun hlt =>
        hgap E hE ⟨lt_of_le_of_ne (hpos E hE) (Ne.symm hzero), hlt⟩))
  · rintro ⟨hΔ, hgap⟩
    refine ⟨hΔ, ?_⟩
    intro E hE hbetween
    rcases hgap E hE with hzero | hle
    · exact (ne_of_gt hbetween.1) hzero
    · exact (not_lt_of_ge hle) hbetween.2

/-- A positive spectral energy bounds every admissible gap from above.
This does not require that this energy be an eigenvalue. -/
theorem gaps_bounded_of_positive_spectral_value (σ : Set ℝ)
    {E : ℝ} (hE : E ∈ σ) (hpositive : 0 < E) :
    BddAbove (admissibleGaps σ) := by
  refine ⟨E, ?_⟩
  intro Δ hΔ
  exact le_of_not_gt (fun hlt => hΔ.2 E hE ⟨hpositive, hlt⟩)

end YangMills
