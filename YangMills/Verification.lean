import YangMills.Classical
import YangMills.Audit

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
