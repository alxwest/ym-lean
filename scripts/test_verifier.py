#!/usr/bin/env python3
"""Regression tests for the source-locked, fail-closed proof verifier."""
from __future__ import annotations

import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
import verify_submission as v  # noqa: E402


class SourceContractTests(unittest.TestCase):
    def test_provenance_records_git_state(self):
        commit = subprocess.CompletedProcess(["git"], 0, "abc123\n", "")
        dirty = subprocess.CompletedProcess(["git"], 0, " M README.md\n", "")
        with patch.object(v, "_run", side_effect=[commit, dirty]) as call:
            record = v.provenance(ROOT)
        self.assertEqual(record["git_commit"], "abc123")
        self.assertTrue(record["git_worktree_dirty"])
        self.assertEqual(call.call_args_list[0].args[0],
                         ["git", "rev-parse", "HEAD"])
        self.assertEqual(call.call_args_list[1].args[0],
                         ["git", "status", "--porcelain"])

    def test_pdf_is_identical_to_pinned_clay_source(self):
        record = v.load_inventory(ROOT)
        self.assertEqual(record["source"]["git_blob_sha1"], v.PDF_BLOB_SHA1)
        self.assertEqual(len(record["requirements"]), len(v.CLAUSE_IDS))

    def test_new_observable_definitions_remain_necessary_only(self):
        inventory = v.load_inventory(ROOT)
        by_id = {e["id"]: e for e in inventory["requirements"]}
        for key in ("gauge-observables", "renormalized-filtration",
                    "ultraviolet", "universal-existence"):
            self.assertEqual(by_id[key]["status"], "partial")
        for key in ("ym-identification", "nontrivial"):
            self.assertEqual(by_id[key]["status"], "missing")
        for key in ("stress-tensor", "ope"):
            self.assertEqual(by_id[key]["status"], "partial")
        report, rc = v.verify(ROOT, "clay",
                              theorem="YangMills.qft_exists_implies_groupwise_qft")
        self.assertEqual(rc, 2)
        self.assertFalse(report["clay_certificate"])
        self.assertIn("ym-identification", report["incomplete_clauses"])

    def test_group_dependent_lattice_does_not_unlock_certificate(self):
        inventory = v.load_inventory(ROOT)
        by_id = {x["id"]: x for x in inventory["requirements"]}
        self.assertEqual(by_id["ym-identification"]["status"], "missing")
        self.assertIn("YangMills.periodicFourClassAction",
                      by_id["ym-identification"]["lean"])
        self.assertIn("YangMills.qft_exists_implies_unlinked_group_checks",
                      by_id["universal-existence"]["lean"])
        report, rc = v.verify(ROOT, "clay")
        self.assertEqual(rc, 2)
        self.assertFalse(report["clay_certificate"])
        for filename in ("YangMills/GaugeHolonomy.lean",
                         "YangMills/LatticeGaugeAction.lean",
                         "YangMills/PeriodicLattice4.lean"):
            self.assertIn(filename,
                          report["provenance"]["local_fingerprints_sha256"])

    def test_qft_nonvacuum_result_does_not_identify_yang_mills(self):
        inventory = v.load_inventory(ROOT)
        requirement = next(e for e in inventory["requirements"]
                           if e["id"] == "nontrivial")
        theorem = "YangMills.GappedWightmanTheory.hasFieldExcitation"
        self.assertIn(theorem, requirement["lean"])
        self.assertEqual(requirement["status"], "missing")
        report, code = v.verify(ROOT, "clay", theorem=theorem)
        self.assertEqual(code, 2)
        self.assertFalse(report["clay_certificate"])
        self.assertIn("nontrivial", report["incomplete_clauses"])
        self.assertIn("YangMills/Nontriviality.lean",
                      report["provenance"]["local_fingerprints_sha256"])

    def test_footnote_expectation_is_not_a_mandatory_theorem(self):
        inventory = v.load_inventory(ROOT)
        by_id = {e["id"]: e for e in inventory["requirements"]}
        hint = by_id["renormalized-filtration"]
        self.assertEqual(hint["acceptance_role"], "interpretive_guidance")
        self.assertEqual(hint["source_basis"], "section_4_footnote_1")
        report, code = v.verify(ROOT, "clay")
        self.assertEqual(code, 2)
        self.assertIn("renormalized-filtration", report["interpretive_guidance"])
        self.assertNotIn("renormalized-filtration", report["incomplete_clauses"])
        self.assertEqual(len(report["incomplete_clauses"]), 11)

    def test_promoting_footnote_expectation_to_hard_requirement_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = self.copy_source(Path(tmp))
            inventory = json.loads((root / v.MANIFEST).read_text())
            hint = next(e for e in inventory["requirements"]
                        if e["id"] == "renormalized-filtration")
            hint["acceptance_role"] = "required"
            (root / v.MANIFEST).write_text(json.dumps(inventory))
            report, code = v.verify(root, "clay")
            self.assertEqual(code, 1)
            self.assertEqual(report["status"], "INVALID_SPECIFICATION")
            self.assertIn("changed acceptance scope", report["error"])

    def test_relabeling_source_section_fails(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = self.copy_source(Path(tmp))
            inventory = json.loads((root / v.MANIFEST).read_text())
            requirement = next(e for e in inventory["requirements"]
                               if e["id"] == "physical-gap")
            requirement["source_basis"] = "section_4_footnote_1"
            (root / v.MANIFEST).write_text(json.dumps(inventory))
            report, code = v.verify(root, "clay")
            self.assertEqual(code, 1)
            self.assertIn("changed acceptance scope", report["error"])

    def test_literal_and_interpretive_lean_have_separate_provenance(self):
        inventory = v.load_inventory(ROOT)
        levels = {entry["id"]: entry["formalization_layer"]
                  for entry in inventory["requirements"]}
        self.assertEqual({key for key, value in levels.items()
                          if value == "literal_form"},
                         {"group", "spacetime", "physical-gap",
                          "universal-existence"})
        self.assertEqual(levels["qft-axioms"], "cited_framework")
        self.assertEqual(levels["ym-identification"], "interpretation_needed")
        self.assertEqual(levels["gauge-observables"], "interpretation_needed")
        self.assertEqual(levels["renormalized-filtration"], "nonbinding_guidance")
        self.assertIn("PDF_EXPLICIT", (ROOT / "YangMills/PDFLiteral.lean").read_text())
        self.assertIn("YangMills.PDFLiteral.HamiltonianKillsVacuum",
                      next(e for e in inventory["requirements"]
                           if e["id"] == "physical-gap")["lean"])
        self.assertIn("interpretationStillNeeded",
                      (ROOT / "YangMills/SourceClassification.lean").read_text())
        report, code = v.verify(ROOT, "clay")
        self.assertEqual(code, 2)
        self.assertEqual(report["formalization_layers"], levels)
        self.assertFalse(report["clay_certificate"])

    def test_cannot_relabel_unfinished_interpretation_as_pdf_literal(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = self.copy_source(Path(tmp))
            inventory = json.loads((root / v.MANIFEST).read_text())
            target = next(e for e in inventory["requirements"]
                          if e["id"] == "ym-identification")
            target["formalization_layer"] = "literal_form"
            (root / v.MANIFEST).write_text(json.dumps(inventory))
            report, code = v.verify(root, "clay")
            self.assertEqual(code, 1)
            self.assertEqual(report["status"], "INVALID_SPECIFICATION")
            self.assertIn("provenance classification", report["error"])

    def test_cannot_change_literal_quantifier_into_an_interpretation(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = self.copy_source(Path(tmp))
            inventory = json.loads((root / v.MANIFEST).read_text())
            target = next(e for e in inventory["requirements"]
                          if e["id"] == "group")
            target["formalization_layer"] = "interpretation_needed"
            (root / v.MANIFEST).write_text(json.dumps(inventory))
            report, code = v.verify(root, "clay")
            self.assertEqual(code, 1)
            self.assertIn("provenance classification", report["error"])

    def test_full_clay_certificate_fails_closed_even_without_proof(self):
        report, code = v.verify(ROOT, "clay")
        self.assertEqual(code, 2)
        self.assertEqual(report["status"], "CLAY_CERTIFICATION_BLOCKED")
        self.assertFalse(report["clay_certificate"])
        self.assertIn("ym-identification", report["incomplete_clauses"])

    def test_adversarial_status_metadata_cannot_enable_clay(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = self.copy_source(Path(tmp))
            inventory = json.loads((root / v.MANIFEST).read_text())
            for req in inventory["requirements"]:
                req["status"] = "formalized"
            (root / v.MANIFEST).write_text(json.dumps(inventory))
            report, code = v.verify(root, "clay")
            self.assertEqual(code, 2)
            self.assertFalse(report["clay_certificate"])
            self.assertEqual(report["incomplete_clauses"], [])

    def test_specification_readiness_does_not_require_existence_proof(self):
        report, code = v.verify(ROOT, "specification")
        self.assertEqual(code, 2)
        self.assertEqual(report["status"], "SPECIFICATION_INCOMPLETE")
        self.assertFalse(report["existence_proof_required_for_specification"])
        self.assertEqual(report["proof_submission_status"], "not_submitted")
        self.assertEqual(report["kernel_verification_status"], "not_run")
        self.assertFalse(report["full_target_defined"])

    def test_supplied_proof_cannot_bypass_missing_specification(self):
        report, code = v.verify(ROOT, "specification", proof_file=Path("Candidate.lean"))
        self.assertEqual(code, 2)
        self.assertEqual(report["proof_submission_status"],
                         "not_evaluated_specification_incomplete")
        self.assertEqual(report["external_acceptance_status"], "not_assessed")

    def test_tampered_pdf_is_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = self.copy_source(Path(tmp))
            with (root / v.PDF_RELATIVE).open("ab") as fh:
                fh.write(b"\nThis PDF was modified.\n")
            report, code = v.verify(root, "clay")
            self.assertEqual(code, 1)
            self.assertEqual(report["status"], "INVALID_SPECIFICATION")
            self.assertFalse(report["pdf_hash_verified"])

    def test_removing_requirement_cannot_silently_reduce_scope(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = self.copy_source(Path(tmp))
            inventory = json.loads((root / v.MANIFEST).read_text())
            inventory["requirements"] = [r for r in inventory["requirements"]
                                         if r["id"] != "ultraviolet"]
            (root / v.MANIFEST).write_text(json.dumps(inventory))
            report, code = v.verify(root, "clay")
            self.assertEqual(code, 1)
            self.assertIn("incomplete", report["error"])

    def test_qft_only_never_sets_clay_certificate(self):
        with tempfile.TemporaryDirectory() as tmp:
            proof = Path(tmp) / "Candidate.lean"
            proof.write_text("theorem Foo : True := True.intro\n")
            compile_ok = subprocess.CompletedProcess(["lake"], 0, "", "")
            audit_ok = subprocess.CompletedProcess(["lean"], 0, "QFT_KERNEL_CHECK_PASSED: Foo\n", "")
            # Git provenance has its own subprocesses; these responses model
            # only the build, candidate compilation and independent inspector.
            with patch.object(v, "provenance", return_value={}), \
                    patch.object(v, "_run", side_effect=[compile_ok, compile_ok, audit_ok]) as call:
                report, code = v.verify(ROOT, "qft", proof_file=proof, theorem="Foo")
            self.assertEqual(code, 0)
            self.assertTrue(report["qft_only_certificate"])
            self.assertEqual(report["kernel_verification_status"], "passed_declared_qft_target")
            self.assertEqual(report["specification_readiness"], "incomplete")
            self.assertEqual(report["semantic_review_status"], "unresolved_findings")
            self.assertEqual(report["external_acceptance_status"], "not_assessed")
            self.assertFalse(report["clay_certificate"])
            self.assertEqual(call.call_count, 3)
            submitted_copy = Path(call.call_args_list[1].args[0][-1])
            self.assertFalse(submitted_copy.exists())

    def test_qft_wrong_target_or_failed_audit_cannot_pass(self):
        with tempfile.TemporaryDirectory() as tmp:
            proof = Path(tmp) / "Wrong.lean"
            proof.write_text("theorem Foo : True := True.intro\n")
            ok = subprocess.CompletedProcess(["lake", "build"], 0, "", "")
            reject = subprocess.CompletedProcess(["lean"], 1, "REJECTED: wrong type\n", "")
            with patch.object(v, "provenance", return_value={}), \
                    patch.object(v, "_run", side_effect=[ok, ok, reject]):
                report, code = v.verify(ROOT, "qft", proof_file=proof, theorem="Foo")
            self.assertEqual(code, 1)
            self.assertEqual(report["status"], "PROOF_REJECTED")
            self.assertFalse(report["qft_only_certificate"])
            self.assertIsNone(report["admitted_target"])

    def test_spoofed_success_message_in_candidate_is_not_evidence(self):
        with tempfile.TemporaryDirectory() as tmp:
            proof = Path(tmp) / "Spoof.lean"
            proof.write_text('theorem Fake : True := True.intro\n')
            compiled = subprocess.CompletedProcess(["lean"], 0, "QFT-and-gap target checked.\n", "")
            inspect_reject = subprocess.CompletedProcess(["lean"], 1, "REJECTED: wrong type\n", "")
            with patch.object(v, "provenance", return_value={}), \
                    patch.object(v, "_run", side_effect=[compiled, compiled, inspect_reject]):
                report, code = v.verify(ROOT, "qft", proof_file=proof, theorem="Fake")
            self.assertEqual(code, 1)
            self.assertEqual(report["status"], "PROOF_REJECTED")
            self.assertFalse(report["qft_only_certificate"])

    def test_unsafe_theorem_name_is_not_interpreted_as_code(self):
        with tempfile.TemporaryDirectory() as tmp:
            proof = Path(tmp) / "Proof.lean"
            proof.write_text("theorem Foo : True := True.intro\n")
            report, code = v.verify(ROOT, "qft", proof_file=proof,
                                    theorem="Foo\n#print axioms Mathlib")
            self.assertEqual(code, 1)
            self.assertFalse(report["qft_only_certificate"])

    @staticmethod
    def copy_source(root: Path) -> Path:
        (root / "source").mkdir()
        shutil.copy2(ROOT / v.PDF_RELATIVE, root / v.PDF_RELATIVE)
        shutil.copy2(ROOT / v.MANIFEST, root / v.MANIFEST)
        return root


if __name__ == "__main__":
    unittest.main()
