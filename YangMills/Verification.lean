import YangMills.Classical
import YangMills.Audit
import YangMills.LocalObservables
import YangMills.QuantumCorrelations
import YangMills.GroupwiseNecessary

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
