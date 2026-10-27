import YangMills.YangMillsSpecification

set_option backward.isDefEq.respectTransparency false
set_option warningAsError true

/-!
# Proposed existence-only Yang--Mills target

A *separate*, weaker target for an interacting four-dimensional Yang--Mills
QFT. The full existence-and-mass-gap target is unchanged.

The existence candidate requires the same gauge-dependent generated sector,
physical Wightman theory, vacuum kernels, ultraviolet/OPE matching, Ward
identities, composite observables, and stress-tensor/Hamiltonian identification
as the existing full target. Unlike FilteredGeneratedCandidate, it does not
require a positive or finite physical spectral gap.

Nontriviality is required explicitly of fields on the SAME physical Hilbert
space, because it is no longer implied by the positive finite mass property.

This is a proposed sufficient presentation for Yang--Mills *existence*, not a
proof of existence or a claim of established semantic equivalence to the
unpublished OpenAI construction or to every wording of the source problem.
-/

noncomputable section
namespace YangMills
universe u
open Perturbative PerturbativeFlow

/-- Candidate for one actual compact connected simple group. No mass-gap
assumption appears among its fields or the referenced generated-sector fields. -/
structure FilteredExistenceCandidate (G : CompactSimpleGaugeGroup) where
  theory : QuantumTheory
  qft_axioms : WightmanAxioms theory.State theory.fields
  fieldExcitation : theory.fields.HasFieldExcitation
  vacuumKernels : WightmanVacuumKernels theory.fields
  form : InvariantForm G
  colorFrame : ColorFrame form
  engine : FixedFlowSystem colorFrame
  wardFamily : LocalWardFlowFamily engine
  basis : OPE.FilteredBasis G
  generated : LocalWardCoefficientFamily wardFamily basis
  normalization : GeneratedScaleNormalization wardFamily
  composites : RenormalizedCompositeMap theory.fields G
  kernels : OPE.MultiKernels composites
  coefficients : OPE.MultiCoefficients basis
  physicalCoefficients : ℕ → OPE.MultiCoefficients basis
  stress : StressTensorData theory.fields G composites
  curvatureSquare : CurvatureJetPolynomial.invariantAlgebra G
  sector : FilteredRG.GeneratedSector wardFamily basis generated normalization
    kernels coefficients physicalCoefficients stress curvatureSquare

/-- Proposed four-dimensional Yang--Mills existence-only claim for EVERY
actual compact connected simple Lie group. This does not assert a mass gap. -/
def YangMillsExistenceOnly : Prop :=
  ∀ G : CompactSimpleGaugeGroup.{u}, Nonempty (FilteredExistenceCandidate G)

/-- Full candidates supply existence-only candidates, without introducing
any new physical assumptions. The reverse implication is NOT asserted. -/
def FilteredGeneratedCandidate.toExistenceOnly {G : CompactSimpleGaugeGroup}
    (candidate : FilteredGeneratedCandidate G) : FilteredExistenceCandidate G where
  theory := candidate.theory
  qft_axioms := candidate.qft_and_gap.axioms
  fieldExcitation := candidate.qft_and_gap.hasFieldExcitation
  vacuumKernels := candidate.vacuumKernels
  form := candidate.form
  colorFrame := candidate.colorFrame
  engine := candidate.engine
  wardFamily := candidate.wardFamily
  basis := candidate.basis
  generated := candidate.generated
  normalization := candidate.normalization
  composites := candidate.composites
  kernels := candidate.kernels
  coefficients := candidate.coefficients
  physicalCoefficients := candidate.physicalCoefficients
  stress := candidate.stress
  curvatureSquare := candidate.curvatureSquare
  sector := candidate.sector

/-- The full (existence-and-gap) target implies the weaker existence-only
target, without asserting that either has a proof. -/
theorem existenceOnly_of_existenceAndMassGap
    (h : YangMillsExistenceAndMassGap.{u}) : YangMillsExistenceOnly.{u} := by
  intro G
  obtain ⟨candidate⟩ := h G
  exact ⟨candidate.toExistenceOnly⟩

end YangMills
