#!/usr/bin/env python3
"""Build the specification and regression-test its proof audit.

This does NOT certify the full Yang–Mills problem. See README.md.
The negative fixtures deliberately contain forbidden assumptions/proof holes;
they are generated under .lake and are never library declarations.
"""
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def lean(source: str, directory: Path, name: str) -> subprocess.CompletedProcess:
    path = directory / f"{name}.lean"
    path.write_text(source)
    return subprocess.run(
        ["lake", "env", "lean", str(path)], cwd=ROOT,
        text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
    )


def main() -> None:
    subprocess.run([sys.executable, "-m", "unittest", "discover", "-s", "scripts",
                    "-p", "test_verifier.py"], cwd=ROOT, check=True)
    subprocess.run(["lake", "build"], cwd=ROOT, check=True)
    cases = [
        ("honest_proof", "theorem honest : True := True.intro\n#audit_axioms honest", True, "Axiom audit passed"),
        ("library_proofs", "\n".join([
            "#audit_axioms YangMills.mass_pos",
            "#audit_axioms YangMills.RenormalizedCompositeMap.Compatible",
            "#audit_axioms YangMills.StressTensorData.not_zero_tensor_of_massGap",
            "#audit_axioms YangMills.Perturbative.bareCompositeCoefficient",
            "#audit_axioms YangMills.RG.CoupledSectorConditions",
            "#audit_axioms YangMills.mass_isMassGap",
            "#audit_axioms YangMills.WightmanAxioms.field_graph_limit_zero",
            "#audit_axioms YangMills.WightmanAxioms.hamiltonian_action_unique",
            "#audit_axioms YangMills.CurvatureJetPolynomial.ConnectionObservable.finite_dimension",
            "#audit_axioms YangMills.WightmanData.selfSelectedExpansion",
            "#audit_axioms YangMills.vacuum_only_has_no_finite_mass",
            "#audit_axioms YangMills.isMassGap_iff",
            "#audit_axioms YangMills.gaps_bounded_of_positive_spectral_value",
            "#audit_axioms YangMills.DenselyDefinedOperator.eigenvalue_mem_spectrum",
            "#audit_axioms YangMills.WightmanAxioms.vacuum_mem_spectrum",
            "#audit_axioms YangMills.PoincareTransform.act_compose",
            "#audit_axioms YangMills.QFTExistenceAndMassGap",
        ]), True, "Axiom audit passed"),
        ("direct_sorry", "theorem bad : True := by sorry\n#audit_axioms bad", False, "sorryAx"),
        ("hidden_sorry", "theorem hidden : True := by sorry\ntheorem bad : True := hidden\n#audit_axioms bad", False, "sorryAx"),
        ("custom_axiom", "axiom oracle : True\ntheorem bad : True := oracle\n#audit_axioms bad", False, "oracle"),
        ("assumed_target", "axiom oracle : YangMills.QFTExistenceAndMassGap\n#check_qft_proof oracle", False, "Proof audit rejected"),
        ("wrong_target", "theorem unrelated : True := True.intro\n#check_qft_proof unrelated", False, "Wrong target"),
        ("conditional_target", "theorem conditional (h : YangMills.QFTExistenceAndMassGap) : YangMills.QFTExistenceAndMassGap := h\n#check_qft_proof conditional", False, "Wrong target"),
        ("ex_falso", "theorem conditional (h : False) : YangMills.QFTExistenceAndMassGap := h.elim\n#check_qft_proof conditional", False, "Wrong target"),
        ("removed_placeholder", "#check YangMills.Framework", False, "Unknown identifier"),
        ("no_premature_full_target", "#check YangMills.YangMillsExistenceAndMassGap", False, "Unknown identifier"),
        ("clay_status", "#clay_certification_status", True, "CLAY_CERTIFICATION_BLOCKED"),
        ("clay_rejects_true", "theorem unrelated : True := True.intro\n#check_clay_proof unrelated", False, "CLAY_CERTIFICATION_BLOCKED"),
        ("clay_rejects_assumed_qft", "axiom oracle : YangMills.QFTExistenceAndMassGap\n#check_clay_proof oracle", False, "CLAY_CERTIFICATION_BLOCKED"),
        ("clay_rejects_group_agnostic", "theorem merely_group_indexed (h : YangMills.QFTExistenceAndMassGap) : ∀ (_G : YangMills.CompactSimpleGaugeGroup), YangMills.QFTExistenceAndMassGap := by\n  intro _G\n  exact h\n#check_clay_proof merely_group_indexed", False, "CLAY_CERTIFICATION_BLOCKED"),
    ]
    with tempfile.TemporaryDirectory(prefix="proof-audit-", dir=ROOT / ".lake") as tmp:
        directory = Path(tmp)
        for name, body, success, marker in cases:
            result = lean("import YangMills\n" + body + "\n", directory, name)
            if (result.returncode == 0) != success or marker not in result.stdout:
                raise SystemExit(f"FAIL {name}\n{result.stdout}")
            print(f"PASS {name}", flush=True)
    print(f"All {len(cases)} proof-audit checks passed.")
    subprocess.run([sys.executable, "scripts/test_kernel_inspector.py"], cwd=ROOT, check=True)


if __name__ == "__main__":
    main()
