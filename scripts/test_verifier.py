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
        for key in ("ym-identification", "stress-tensor", "ope", "nontrivial"):
            self.assertEqual(by_id[key]["status"], "missing")
        report, rc = v.verify(ROOT, "clay",
                              theorem="YangMills.qft_exists_implies_groupwise_qft")
        self.assertEqual(rc, 2)
        self.assertFalse(report["clay_certificate"])
        self.assertIn("ym-identification", report["incomplete_clauses"])

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
            with patch.object(v, "_run", side_effect=[compile_ok, compile_ok, audit_ok]) as call:
                report, code = v.verify(ROOT, "qft", proof_file=proof, theorem="Foo")
            self.assertEqual(code, 0)
            self.assertTrue(report["qft_only_certificate"])
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
            with patch.object(v, "_run", side_effect=[ok, ok, reject]):
                report, code = v.verify(ROOT, "qft", proof_file=proof, theorem="Foo")
            self.assertEqual(code, 1)
            self.assertEqual(report["status"], "PROOF_REJECTED")
            self.assertFalse(report["qft_only_certificate"])

    def test_spoofed_success_message_in_candidate_is_not_evidence(self):
        with tempfile.TemporaryDirectory() as tmp:
            proof = Path(tmp) / "Spoof.lean"
            proof.write_text('theorem Fake : True := True.intro\n')
            compiled = subprocess.CompletedProcess(["lean"], 0, "QFT-and-gap target checked.\n", "")
            inspect_reject = subprocess.CompletedProcess(["lean"], 1, "REJECTED: wrong type\n", "")
            with patch.object(v, "_run", side_effect=[compiled, compiled, inspect_reject]):
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
