"""Regression tests for the source census, without fetching or executing Lean."""
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from xml.etree import ElementTree

import compare_subproofs as c


def file(count, imports=()):
    return {"declarations": count, "imports": list(imports), "kinds": {},
            "sorry_tokens": 0}


class CensusTests(unittest.TestCase):
    def test_nested_comments_and_strings(self):
        source = '''/- hidden
theorem ignored : True := by trivial
/- inner -- ignored as comment text -/ -/
@[simp] theorem real : True := by trivial -- theorem fake
private noncomputable def x : Nat := 0
instance : Inhabited Nat := inferInstance
instance named : Inhabited Nat := inferInstance
def text := "theorem fake : True"
-- sorry
'''
        text = c.clean(source)
        self.assertEqual(c.DECL.findall(text), ["theorem", "def", "instance", "def"])
        self.assertNotIn("sorry", text)

    def test_dependency_union_diamond(self):
        files = {"A.lean": file(3, ("B", "C", "Mathlib")),
                 "B.lean": file(5, ("D",)), "C.lean": file(7, ("D",)),
                 "D.lean": file(11)}
        mods = {x[:-5]: [x] for x in files}
        seen, outside, issues = c.closure(["A.lean", "B.lean"], files, mods)
        self.assertEqual(sum(files[x]["declarations"] for x in seen), 26)
        self.assertEqual(outside, {"Mathlib"})
        self.assertFalse(issues)

    def test_missing_and_ambiguous_roots(self):
        files = {"A.lean": file(1, ("B",))}
        _, _, issues = c.closure(["A.lean", "Absent.lean"], files,
                                 {"B": ["B1.lean", "B2.lean"]})
        self.assertEqual(issues, {"Missing root: Absent.lean", "Ambiguous project import: B"})

    def test_glob_root_level_and_exclusions(self):
        self.assertTrue(c.matches("YM/Basic.lean", "YM/**/*.lean"))
        self.assertTrue(c.matches("YM/X/Basic.lean", "YM/**/*.lean"))
        self.assertFalse(c.matches("Other/Basic.lean", "YM/**/*.lean"))
        self.assertFalse(c.safe_path("../elsewhere"))
        self.assertFalse(c.safe_path("/etc/passwd"))

    def test_registry_maps_every_requirement(self):
        registry = json.loads((c.ROOT/"source/subproofs/registry.json").read_text())
        requirements = json.loads((c.ROOT/"source/requirements.json").read_text())
        c.validate(registry, requirements)
        self.assertGreaterEqual(len(registry["projects"]), 18)
        self.assertGreaterEqual(len(registry["areas"]), 15)

    def test_new_revision_keeps_assessed_four_state_status(self):
        p = {"id": "P", "label": "P", "repository": "x/y", "ref": "HEAD",
             "scope": "finite", "reviewed_on": "2026-11-25",
             "review_evidence": "README.md", "reviewed_revision": "a"*40,
             "cells": {"gibbs": {"status": "complete", "roots": ["A.lean"]},
                       "gap": {"status": "open", "roots": []},
                       "partial": {"status": "partial", "roots": ["A.lean"]},
                       "conditional": {"status": "conditional", "roots": ["A.lean"]}}}
        files = {"A.lean": file(7)}
        with patch.object(c, "prepare", return_value=(Path("."), "b"*40)), \
             patch.object(c, "inventory", return_value=(files, {"A": ["A.lean"]}, [])):
            r = c.analyze(p, Path("."), "latest", False)
        self.assertEqual(r["cells"]["gibbs"]["status"], "complete")
        self.assertEqual(r["cells"]["gibbs"]["count_status"], "counted")
        self.assertEqual(r["revision"], "b"*40)
        self.assertEqual(r["reviewed_revision"], "a"*40)
        self.assertEqual(r["cells"]["gap"]["status"], "open")
        self.assertEqual(r["cells"]["partial"]["status"], "partial")
        self.assertEqual(r["cells"]["conditional"]["status"], "conditional")
        self.assertEqual(r["cells"]["gibbs"]["reviewed_status"], "complete")
        self.assertEqual(r["cells"]["gibbs"]["declarations"], 7)
        self.assertIsNone(r["cells"]["gap"]["declarations"])
        self.assertEqual(r["union_declarations"], 7)

    def test_missing_root_fails_closed(self):
        p = {"id": "P", "label": "P", "repository": "x/y", "ref": "HEAD",
             "scope": "finite", "reviewed_on": "2026-11-25",
             "review_evidence": "README.md", "reviewed_revision": "a"*40,
             "cells": {"gibbs": {"status": "complete", "roots": ["Missing.lean"]}}}
        with patch.object(c, "prepare", return_value=(Path("."), "a"*40)), \
             patch.object(c, "inventory", return_value=({"A.lean": file(7)}, {"A": ["A.lean"]}, [])):
            r = c.analyze(p, Path("."), "reviewed", False)
        self.assertTrue(r["errors"])
        self.assertEqual(r["cells"]["gibbs"]["status"], "complete")
        self.assertEqual(r["cells"]["gibbs"]["count_status"], "unavailable")
        self.assertIsNone(r["cells"]["gibbs"]["declarations"])

    def test_private_source_redacts_dependency_metadata(self):
        p = {"id": "P", "label": "P", "repository": "alxwest/ym", "ref": "HEAD",
             "scope": "finite", "reviewed_on": "2026-11-25",
             "review_evidence": "README.md", "reviewed_revision": "a"*40,
             "private_source": True,
             "cells": {"gibbs": {"status": "complete", "roots": ["A.lean"]}}}
        files = {"A.lean": file(7)}
        with patch.object(c, "prepare", return_value=(Path("."), "a"*40)), \
             patch.object(c, "inventory", return_value=(files, {"A": ["A.lean"]}, [])):
            r = c.analyze(p, Path("."), "reviewed", True)
        self.assertNotIn("source_inventory", r)
        cell = r["cells"]["gibbs"]
        self.assertEqual(cell["declarations"], 7)
        self.assertEqual(cell["roots"], [])
        self.assertNotIn("closure_files", cell)

    def test_chart_is_xml_and_omits_open_cells(self):
        report = {"areas": [{"id": "a", "label": "A & B"}, {"id": "b", "label": "Other"}],
                  "projects": [{"label": "P < Q", "revision": "a"*40, "cells": {
                      "a": {"status": "partial", "reviewed_status": "partial", "declarations": 17},
                      "b": {"status": "open", "reviewed_status": "open", "declarations": 99999}}}]}
        with tempfile.TemporaryDirectory() as d:
            c.write_svg(report, Path(d))
            root = ElementTree.parse(Path(d)/"subproof-chart.svg").getroot()
            titles = root.findall(".//{http://www.w3.org/2000/svg}title")
            self.assertEqual(len(titles), 2)
            self.assertNotIn("99,999", (Path(d)/"subproof-chart.svg").read_text())
            self.assertNotIn("#c62828", (Path(d)/"subproof-chart.svg").read_text())
            self.assertIn("P < Q", titles[1].text)
            self.assertIn("17", titles[1].text)

    def test_open_cells_blank_in_markdown_but_counts_remain_in_csv(self):
        import csv
        cells = {
            "a": {"status": "complete", "reviewed_status": "complete",
                  "declarations": 17, "roots": ["A.lean"]},
            "b": {"status": "open", "reviewed_status": "open",
                  "declarations": 99999, "roots": ["B.lean"]},
        }
        report = {"mode": "reviewed", "reference_revision": "a"*40,
                  "areas": [{"id": "a", "label": "A", "requirement_ids": []},
                            {"id": "b", "label": "B", "requirement_ids": []}],
                  "projects": [{"label": "P", "repository": "x/y", "scope": "finite",
                                "revision": "a"*40, "reviewed_revision": "a"*40,
                                "review_evidence": "README.md", "errors": [],
                                "total_modules": 2, "total_declarations": 100016,
                                "union_declarations": 100016, "cells": cells}]}
        md = c.markdown(report)
        self.assertIn("| P | 🟢 17 |  |", md)
        self.assertNotIn("99,999", md)
        self.assertNotIn("🔴", md)
        with tempfile.TemporaryDirectory() as d:
            c.write_csv(report, Path(d))
            with (Path(d)/"subproofs.csv").open() as f:
                rows = list(csv.DictReader(f))
            self.assertEqual(rows[1]["status"], "open")
            self.assertEqual(rows[1]["declarations"], "99999")
        self.assertEqual(cells["b"]["declarations"], 99999)


if __name__ == "__main__":
    unittest.main()
