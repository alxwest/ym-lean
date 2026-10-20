import YangMills.Renormalization
import YangMills.RenormalizationGroup
import Lean
import YangMills.PDFLiteral
import YangMills.QFT.Wightman
import YangMills.LocalObservables
import YangMills.QuantumCorrelations
import YangMills.PeriodicLattice4
import YangMills.GroupwiseNecessary
import YangMills.Nontriviality
import YangMills.InvariantJetPolynomials
import YangMills.Ultraviolet

/-!
# Provenance labels for the formal specification

These labels are review metadata, not Lean hypotheses or axioms.

* directMath: the directly written mathematical FORM of a Section 4 clause
* citedStandard: mathematics obtained from the cited mathematical frameworks
* interpretedModel: a chosen Lean encoding of natural-language requirements
* optionalMethod: possible proof machinery, never a mandatory theorem clause

Unformalized interpretive requirements below are strings only. We deliberately
do not define an arbitrary "IsYangMills : Prop" to bypass missing semantics.
-/

open Lean Elab Command

namespace YangMills.PDFOrigin

inductive Layer where
  | directMath
  | citedStandard
  | interpretedModel
  | optionalMethod
deriving DecidableEq, Repr, Inhabited

structure Mark where
  declaration : Name
  layer : Layer
  sourceLocation : String
  scopeNote : String

private def declarationName (name : String) : Name :=
  (name.splitOn ".").foldl (fun n c => Name.str n c) Name.anonymous

/-- Reviewed provenance is metadata only. None of these source labels means
that the entire PDF has a complete and correct Lean theorem yet. -/
def marks : List Mark :=
  [
    { declaration := declarationName "YangMills.PDFLiteral.FourDimensionalSpace",
      layer := .directMath, sourceLocation := "section 4 p.6",
      scopeNote := "R^4 coordinate type; not a constructed quantum theory" },
    { declaration := declarationName "YangMills.PDFLiteral.HamiltonianKillsVacuum",
      layer := .directMath, sourceLocation := "section 4 p.6",
      scopeNote := "exact H Omega = 0 equation using interpreted operator domain" },
    { declaration := declarationName "YangMills.PDFLiteral.HamiltonianSpectralFacts",
      layer := .directMath, sourceLocation := "section 4 p.6",
      scopeNote := "positive-energy spectrum and zero vacuum energy" },
    { declaration := declarationName "YangMills.PDFLiteral.PositiveGap",
      layer := .directMath, sourceLocation := "section 4 p.6",
      scopeNote := "open interval (0, delta) avoids spectrum" },
    { declaration := declarationName "YangMills.PDFLiteral.PositiveFiniteMass",
      layer := .directMath, sourceLocation := "section 4 p.6",
      scopeNote := "nonempty bounded family of admissible gaps" },
    { declaration := declarationName "YangMills.PDFLiteral.ForEveryCompactSimpleGroup",
      layer := .directMath, sourceLocation := "section 4 theorem p.6",
      scopeNote := "only the universal binder, not a free certification predicate" },

    { declaration := declarationName "YangMills.CompactSimpleGaugeGroup",
      layer := .citedStandard, sourceLocation := "sections 1 and 4",
      scopeNote := "chosen connected compact simple Lie group encoding" },
    { declaration := declarationName "YangMills.WightmanAxioms",
      layer := .citedStandard, sourceLocation := "sections 3 and 4; refs [45,35]",
      scopeNote := "implementation of a cited QFT axiomatic framework" },

    { declaration := declarationName "YangMills.QuantumTheory",
      layer := .interpretedModel, sourceLocation := "sections 3 and 4",
      scopeNote := "Hilbert/operator-data interpretation of quantum field theory" },
    { declaration := declarationName "YangMills.CurvatureScalarPolynomial.evaluate",
      layer := .interpretedModel, sourceLocation := "section 4 and footnote 1",
      scopeNote := "partial classical observables, not quantum identification" },
    { declaration := declarationName "YangMills.CurvatureJetPolynomial.invariantAlgebra",
      layer := .interpretedModel, sourceLocation := "section 4 local observables",
      scopeNote := "general classical formal-jet invariants; geometric covariance still conditional" },
    { declaration := declarationName "YangMills.WightmanData.scaledVacuumNPoint",
      layer := .interpretedModel, sourceLocation := "section 4 short-distance correlations",
      scopeNote := "actual scaled field words; not prescribed YM asymptotics" },
    { declaration := declarationName "YangMills.WightmanData.selfSelectedExpansion",
      layer := .interpretedModel, sourceLocation := "adversarial logical negative control",
      scopeNote := "freely selected terms make a scalar expansion vacuous" },
    { declaration := declarationName "YangMills.RenormalizedCompositeMap.Compatible",
      layer := .interpretedModel, sourceLocation := "section 4 local fields and footnote 1",
      scopeNote := "same-domain linear correspondence, derivatives, covariance, composite cyclicity; fixed YM predictions still missing" },
    { declaration := declarationName "YangMills.StressTensorData.Compatible",
      layer := .interpretedModel, sourceLocation := "section 4 stress tensor",
      scopeNote := "actual translation charge/core conditions; not exact classical traceless image" },
    { declaration := declarationName "YangMills.OPE.WeakBasisExpansion",
      layer := .interpretedModel, sourceLocation := "section 4 OPE; precise weak presentation needs fidelity review",
      scopeNote := "same-field pair kernels and coherent all-degree remainders; not complete multi-cluster/contact prescription" },
    { declaration := declarationName "YangMills.RG.CoupledSectorConditions",
      layer := .interpretedModel, sourceLocation := "section 4 UV/renormalization",
      scopeNote := "same fields, coefficients, common RG, tensor Wick and stress links; formal inputs NOT yet fixed YM outputs" },
    { declaration := declarationName "YangMills.Perturbative.bareCompositeCoefficient",
      layer := .optionalMethod, sourceLocation := "fixed auxiliary perturbative construction; not a universal nonperturbative regulator",
      scopeNote := "actual-group all-order bare Wick expansion and fixed classical insertions; no renormalized UV/Ward limit" },
    { declaration := declarationName "YangMills.WightmanData.vacuumNPoint",
      layer := .interpretedModel, sourceLocation := "section 4 correlators",
      scopeNote := "vacuum correlation in chosen operator realization" },
    { declaration := declarationName "YangMills.WightmanData.HasNonVacuumState",
      layer := .interpretedModel, sourceLocation := "section 4 nontriviality",
      scopeNote := "excludes vacuum-only states; not full Yang--Mills nontriviality" },
    { declaration := declarationName "YangMills.GappedWightmanTheory.hasFieldExcitation",
      layer := .interpretedModel, sourceLocation := "consequence of chosen QFT and mass definitions",
      scopeNote := "derived excitation in the same theory, not an added assumption" },

    { declaration := declarationName "YangMills.wilsonConjugacyClass_gauge_invariant",
      layer := .optionalMethod, sourceLocation := "not prescribed by section 4",
      scopeNote := "finite/nonlocal gauge model, optional only" },
    { declaration := declarationName "YangMills.periodicFourClassAction",
      layer := .optionalMethod, sourceLocation := "section 6 potential methods",
      scopeNote := "specific periodic-lattice regulator, not an obligation" },
    { declaration := declarationName "YangMills.qft_exists_implies_unlinked_group_checks",
      layer := .optionalMethod, sourceLocation := "logical negative control",
      scopeNote := "classical consistency does not identify a QFT" }
  ]

/-- Requirements that need definitions: they are NOT axioms or hypotheses. -/
def interpretationStillNeeded : List String :=
  [ "nontrivial pure quantum Yang--Mills theory for each G",
    "renormalized correspondence of local gauge-invariant observables",
    "short-distance asymptotic-freedom/renormalization predictions",
    "stress-energy tensor and prescribed OPE singularities",
    "formal adequacy of chosen axioms against the cited standards" ]

/-- Verify existence of tagged declarations, not the physical fidelity of
their classifications. Physical fidelity requires independent review. -/
elab "#audit_pdf_origins" : command => do
  let env ← getEnv
  for entry in marks do
    unless env.contains entry.declaration do
      throwError "Missing declared PDF provenance referent: {entry.declaration}"
  logInfo m!"PDF provenance: {marks.length} declared symbols checked; no interpretive assumption is discharged."

end YangMills.PDFOrigin
