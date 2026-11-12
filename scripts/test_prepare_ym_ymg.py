import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import prepare_ym_ymg


class PrepareTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name) / "ym lean"
        self.submission = Path(self.temp.name) / "submission"
        self.entry = dict(name="mathlib", type="git", url="https://example.test/mathlib",
                          rev="abc", subDir=None, inherited=False,
                          configFile="lakefile.lean", manifestFile="lake-manifest.json")
        self.manifest = dict(version="1.2.0", packagesDir=".lake/packages", packages=[self.entry])
        for directory in (self.root, self.submission):
            directory.mkdir()
            (directory / "lean-toolchain").write_text("leanprover/lean4:v4.32.0\n")
            (directory / "lake-manifest.json").write_text(json.dumps(self.manifest))
        for name in ("Construction.lean", "Solution.lean"):
            (self.submission / name).write_text("-- fixture\n")
        bridge = self.root / "integrations" / "ym_ymg"
        bridge.mkdir(parents=True)
        for name in ("Translation.lean", "Solution.lean"):
            (bridge / name).write_text(f"-- trusted {name}\n")
        self.root_patch = patch.object(prepare_ym_ymg, "ROOT", self.root)
        self.root_patch.start()
        self.addCleanup(self.root_patch.stop)

    def test_matching_pins_generate_path_overrides_without_changing_submission(self):
        original = (self.submission / "lake-manifest.json").read_bytes()
        with patch.object(prepare_ym_ymg.subprocess, "check_output", side_effect=["abc\n", ""]):
            output = prepare_ym_ymg.prepare(self.submission)
        entry = json.loads(output.read_text())["packages"][0]
        self.assertEqual(entry["type"], "path")
        self.assertEqual(entry["dir"], str((self.root / ".lake/packages/mathlib").resolve()))
        self.assertEqual((self.submission / "lake-manifest.json").read_bytes(), original)

    def test_toolchain_mismatch(self):
        (self.submission / "lean-toolchain").write_text("leanprover/lean4:v4.31.0\n")
        with self.assertRaisesRegex(ValueError, "same Lean toolchain"):
            prepare_ym_ymg.prepare(self.submission)

    def test_dependency_mismatch(self):
        self.entry["rev"] = "different"
        (self.submission / "lake-manifest.json").write_text(json.dumps(self.manifest))
        with self.assertRaisesRegex(ValueError, "pins differ"):
            prepare_ym_ymg.prepare(self.submission)

    def test_checkout_mismatch(self):
        with patch.object(prepare_ym_ymg.subprocess, "check_output", return_value="different\n"):
            with self.assertRaisesRegex(ValueError, "pinned revision"):
                prepare_ym_ymg.prepare(self.submission)

    def test_dirty_checkout(self):
        with patch.object(prepare_ym_ymg.subprocess, "check_output", side_effect=["abc\n", " M file\n"]):
            with self.assertRaisesRegex(ValueError, "tracked changes"):
                prepare_ym_ymg.prepare(self.submission)

    def test_wrapper_closure_is_namespaced_and_incremental(self):
        solution = "import Construction\ntheorem YangMills.solution : True := by trivial\n"
        construction = "import Mathlib\nimport PublicTheory\nimport YM.Core\nnamespace YangMills\nend YangMills\n"
        (self.submission / "Solution.lean").write_text(solution)
        (self.submission / "Construction.lean").write_text(construction)
        (self.submission / "PublicTheory.lean").write_text("namespace YangMills\nend YangMills\n")
        (self.submission / "Challenge.lean").write_text("-- unrelated reference\n")
        stage = prepare_ym_ymg.stage_wrappers(self.submission, [], "1.2.0")
        copied = stage / "YMGSubmission/Construction.lean"
        self.assertIn("import YMGSubmission.PublicTheory", copied.read_text())
        self.assertIn("import YM.Core", copied.read_text())
        self.assertIn("namespace YMGSubmission", copied.read_text())
        self.assertFalse((stage / "YMGSubmission/Challenge.lean").exists())
        self.assertEqual((self.submission / "Solution.lean").read_text(), solution)
        self.assertIn("theorem YMGSubmission.solution", (stage / "YMGSubmission/Solution.lean").read_text())
        self.assertEqual((stage / "YMGBridge/Translation.lean").read_text(),
                         "-- trusted Translation.lean\n")
        self.assertEqual((stage / "YMGBridge/Solution.lean").read_text(),
                         "-- trusted Solution.lean\n")
        self.assertIn('name = "YMGBridge"', (stage / "lakefile.toml").read_text())
        timestamp = copied.stat().st_mtime_ns
        prepare_ym_ymg.stage_wrappers(self.submission, [], "1.2.0")
        self.assertEqual(copied.stat().st_mtime_ns, timestamp)


if __name__ == "__main__":
    unittest.main()
