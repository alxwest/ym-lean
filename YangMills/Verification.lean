import YangMills.Renormalization
import YangMills.RenormalizationGroup
import YangMills.Classical
import YangMills.SourceClassification
import YangMills.Audit
import YangMills.LocalObservables
import YangMills.QuantumCorrelations
import YangMills.GroupwiseNecessary
import YangMills.PeriodicLattice4
import YangMills.Nontriviality
import YangMills.InvariantJetPolynomials
import YangMills.Ultraviolet

/-!
# Dependency audit of the specification and its supporting lemmas

This module is part of the default build. Auditing the target traverses its
definitions, including the QFT obligations and operator spectrum. The classical
and gauge definitions are audited separately because they are not yet connected
to the QFT target. No existence proof is asserted here.
-/

#audit_axioms YangMills.CompactSimpleGaugeGroup
#audit_axioms YangMills.Connection.euclideanAction
#audit_axioms YangMills.QFTExistenceAndMassGap
#audit_axioms YangMills.PoincareTransform.act_identity
#audit_axioms YangMills.PoincareTransform.act_compose
#audit_axioms YangMills.PoincareTransform.inverseAct_act
#audit_axioms YangMills.DenselyDefinedOperator.eigenvalue_mem_spectrum
#audit_axioms YangMills.WightmanAxioms.vacuum_mem_spectrum
#audit_axioms YangMills.mass_pos
#audit_axioms YangMills.isMassGap_iff
#audit_axioms YangMills.gaps_bounded_of_positive_spectral_value
#audit_axioms YangMills.no_finite_mass_without_positive_energy
#audit_axioms YangMills.vacuum_only_has_no_finite_mass
#audit_axioms YangMills.WightmanData.HasNonVacuumState
#audit_axioms YangMills.WightmanData.HasFieldExcitation
#audit_axioms YangMills.DenselyDefinedOperator.zero_inResolvent
#audit_axioms YangMills.WightmanAxioms.hasFieldExcitation_iff
#audit_axioms YangMills.WightmanAxioms.no_positive_spectrum_of_no_nonVacuumState
#audit_axioms YangMills.GappedWightmanTheory.hasNonVacuumState
#audit_axioms YangMills.GappedWightmanTheory.hasFieldExcitation

-- Report the missing Clay-level obligations on every default build.
-- All the `#audit_axioms` declarations above are definitions or local lemmas;
-- none is a proof of a complete Yang--Mills existence theorem.
#clay_certification_status

-- Audited concrete fragments of the paper's source-level verification target.
-- These are *definitions* of necessary structures, not Yang--Mills existence.
#audit_axioms YangMills.CurvatureJet.evaluate
#audit_axioms YangMills.CurvatureScalarPolynomial.evaluate
#audit_axioms YangMills.CurvatureScalarPolynomial.add_in_filtration
#audit_axioms YangMills.CurvatureScalarPolynomial.mul_in_filtration
#audit_axioms YangMills.WightmanData.vacuumNPoint
#audit_axioms YangMills.qft_exists_implies_groupwise_qft

#audit_axioms YangMills.actionDensity_eq_curvaturePairs
#audit_axioms YangMills.WightmanData.vacuumNPoint_nil_eq_one

-- Genuine G-dependent lattice objects and negative controls for false identification.
#audit_axioms YangMills.gaugeTransform_comp
#audit_axioms YangMills.gaugeHolonomy_transform
#audit_axioms YangMills.wilsonConjugacyClass_gauge_invariant
#audit_axioms YangMills.squareGaugeLoop_holonomy
#audit_axioms YangMills.finiteCentralPlaquetteAction_gauge_invariant
#audit_axioms YangMills.finiteCentralBoltzmannWeight_gauge_invariant
#audit_axioms YangMills.periodicShift_comm
#audit_axioms YangMills.periodicFourClassAction_gauge_invariant
#audit_axioms YangMills.periodicFourClassBoltzmann_gauge_invariant
#audit_axioms YangMills.qft_exists_implies_unlinked_group_checks

-- PDF clause provenance: declarations exist, but physical fidelity is reviewed separately.
#audit_pdf_origins

-- Direct Section 4 mathematical fragments are kernel-audited separately.
#audit_axioms YangMills.PDFLiteral.FourDimensionalSpace
#audit_axioms YangMills.PDFLiteral.HamiltonianKillsVacuum
#audit_axioms YangMills.PDFLiteral.hamiltonianKillsVacuum_of_wightman
#audit_axioms YangMills.PDFLiteral.HamiltonianSpectralFacts
#audit_axioms YangMills.PDFLiteral.PositiveGap
#audit_axioms YangMills.PDFLiteral.PositiveFiniteMass
#audit_axioms YangMills.PDFLiteral.positiveGap_iff
#audit_axioms YangMills.PDFLiteral.positiveFiniteMass_iff
#audit_axioms YangMills.PDFLiteral.ForEveryCompactSimpleGroup
#audit_axioms YangMills.PDFLiteral.forEveryCompactSimpleGroup_iff
#audit_axioms YangMills.PDFLiteral.DirectSpectralClauses

-- Supporting equivalence/domain work and central observable/UV fragments.
#audit_axioms YangMills.hasPositiveFiniteMass_iff
#audit_axioms YangMills.mass_le_positive_spectral_value
#audit_axioms YangMills.mass_isMassGap
#audit_axioms YangMills.WightmanAxioms.field_graph_limit_zero
#audit_axioms YangMills.WightmanAxioms.hamiltonian_domain_unique
#audit_axioms YangMills.WightmanAxioms.hamiltonian_action_unique
#audit_axioms YangMills.CompactSimpleGaugeGroup.adjoint
#audit_axioms YangMills.CurvatureJetPolynomial.invariantAlgebra
#audit_axioms YangMills.CurvatureJetPolynomial.dimension_add
#audit_axioms YangMills.CurvatureJetPolynomial.dimension_mul
#audit_axioms YangMills.CurvatureJetPolynomial.onConnection_eq_of_covariant_jets
#audit_axioms YangMills.dilateTest
#audit_axioms YangMills.dilateTest_apply
#audit_axioms YangMills.WightmanData.scaledVacuumNPoint
#audit_axioms YangMills.WightmanData.TestwiseExpansion
#audit_axioms YangMills.WightmanData.selfSelectedExpansion

#audit_axioms YangMills.CompactSimpleGaugeGroup.adjoint_one
#audit_axioms YangMills.CompactSimpleGaugeGroup.adjoint_mul
#audit_axioms YangMills.CurvatureJetPolynomial.ConnectionObservable

#audit_axioms YangMills.CurvatureJetPolynomial.transform_one
#audit_axioms YangMills.CurvatureJetPolynomial.transform_mul
#audit_axioms YangMills.CurvatureJetPolynomial.ConnectionObservable.evaluate
#audit_axioms YangMills.CurvatureJetPolynomial.ConnectionObservable.HasDimensionAtMost
#audit_axioms YangMills.CurvatureJetPolynomial.ConnectionObservable.finite_dimension
#audit_axioms YangMills.CurvatureJetPolynomial.ConnectionObservable.monotone
#audit_axioms YangMills.WightmanData.scaledVacuumNPoint_one

-- Central renormalized correspondence, fixed perturbative anchor, and same-field OPE/RG.
#audit_axioms YangMills.RenormalizedCompositeMap
#audit_axioms YangMills.RenormalizedCompositeMap.Compatible
#audit_axioms YangMills.RenormalizedCompositeMap.FiniteMixing
#audit_axioms YangMills.intrinsicEngineeringDimension_le_iff
#audit_axioms YangMills.Connection.poincarePullback
#audit_axioms YangMills.classicalPoincareTransform_unique
#audit_axioms YangMills.StressTensorData.Compatible
#audit_axioms YangMills.StressTensorData.HasTraceAnomaly
#audit_axioms YangMills.StressTensorData.not_zero_tensor_of_massGap
#audit_axioms YangMills.Perturbative.density_expansion
#audit_axioms YangMills.Perturbative.sourceDensity_eq_canonical
#audit_axioms YangMills.Perturbative.canonicalDensity_eq_half_oldDensity
#audit_axioms YangMills.Perturbative.bracket_coordinates
#audit_axioms YangMills.Perturbative.betaTwoLoop
#audit_axioms YangMills.Perturbative.bareCoefficient
#audit_axioms YangMills.Perturbative.bare_normalization_identity
#audit_axioms YangMills.Perturbative.bareNormalizedCoefficient_vacuum
#audit_axioms YangMills.Perturbative.classicalInsertionPolynomial
#audit_axioms YangMills.Perturbative.bareCompositeCoefficient
#audit_axioms YangMills.Perturbative.LocalCounterterm.distribution
#audit_axioms YangMills.OPE.PairKernels
#audit_axioms YangMills.OPE.FilteredBasis
#audit_axioms YangMills.OPE.WeakBasisExpansion
#audit_axioms YangMills.RG.Frame
#audit_axioms YangMills.RG.AllOrderMatch
#audit_axioms YangMills.RG.ExhaustiveMatching
#audit_axioms YangMills.RG.CoupledSectorConditions
#audit_axioms YangMills.Wick.AnalyticContinuation
#audit_axioms YangMills.Wick.LabelRotation
