# Lean subproof comparison

This is a comparative source census for the Jaffe–Witten Yang–Mills problem,
not an exact-target proof checker. It is intentionally separate from
[verify_submission.py](../../scripts/verify_submission.py).

## Run

On GitHub, open **Actions → Lean subproof comparison → Run workflow**.
Choose **latest** (the current tracked upstream heads) or **reviewed** (the
exact commits in [registry.json](registry.json)). The workflow also runs on
Mondays at 05:23 UTC and on changes to the comparison on main.

The job summary includes the full matrix. Download the
`lean-subproof-comparison` artifact for:

- `subproof-chart.svg`: all frameworks and all 15 subproofs in one matrix,
  with a separate linear scale per column; no log scale or selector.
- `report.md`: accessible tables, scope, evidence links and requirement map.
- `subproofs.csv`: one row per framework/subproof, including counts and status.
- `report.json`: resolved commits, registry/specification hashes, reviewed
  statuses, selected roots, lexical warnings and public module import
  inventories, for reproduction and review.

The [initial reviewed chart](baseline.svg) and [baseline report](baseline.md)
are checked-in snapshots, not continuously overwritten. The Actions artifacts
are the refreshed outputs.

### Private DyadicYM source

`alxwest/ym` is private. The workflow's default GITHUB_TOKEN cannot read it.
To opt into aggregate public reporting, create a fine-grained GitHub personal
access token restricted to **alxwest/ym** with **Contents: read-only**, then
add it under **ym-lean → Settings → Secrets and variables → Actions → New
repository secret**, named `YM_SUBPROOF_DYADIC_TOKEN`. Do not place the token
in source, the registry or chat. Rotate it according to its expiration.

The public registry identifies selected module anchors; the public artifacts
contain the private source's commit, aggregate counts, scope and status, but
not its source files, full module inventory or import/dependency names. The
credential is passed only to Git operations for that repository, never in a
URL or command argument. Without this secret the DyadicYM row is explicitly
unavailable; the other rows and the chart are still uploaded, but the workflow
reports an incomplete census (nonzero exit).

To run locally using public sources and (optionally) the environment secret:

```sh
python3 scripts/compare_subproofs.py --mode latest --output subproof-report
```

For an offline replay, place clean committed checkouts in a directory, with
subdirectories matching each registry project ID:

```sh
python3 scripts/compare_subproofs.py --mode reviewed \
  --local-sources /path/to/checkouts --output subproof-report
```

## Metric and review policy

Each cell is the lexical count of **named source declarations** (theorems,
lemmas, definitions, named instances, structures, classes, axioms, etc.) in
the union of selected module roots and the project-local files they import
transitively. Each file is counted once per cell, so different cells can
overlap. `root_declarations` counts only the root modules. The total and
union columns in the report are different metrics, not sums of the cells.
Mathlib and other external packages, tests, archived copies and vendor trees
are excluded from the selected corpus. Some projects include their own
support libraries. Imports outside the selected corpus are recorded for
public projects and not counted. A missing root or ambiguous import fails
closed instead of reporting a false zero.

This is a text census, not a Lean parser or a kernel dependency trace.
Comments and ordinary strings are stripped, and generated constants and
anonymous instances are not counted. The lexical method may count declarations
inside syntax quotations or miss unusual formatting; totals can differ
slightly from earlier inventories or `#print axioms` counts. Source
`axiom` declarations and `sorry`/ `admit` tokens are **warnings**, not a
transitive axiom audit. No external Lean code, scripts, build hooks, or
repository workflows are executed.

The registry records 18 previously surveyed frameworks and 15 comparable
subproofs (including OPE and stress/Ward/trace), with mappings to the
requirement IDs in [requirements.json](../requirements.json). This map is
interpretive: a completed scoped subproof does not discharge the referenced
full specification clause. A completed finite lattice result, for example,
is not a positive continuum mass gap.

- **Complete:** the selected mathematical component is reviewed as proved
  within the stated scope.
- **Partial:** substantive related work exists but the component is incomplete.
- **Conditional:** the component relies on additional unproved inputs.
- **Open:** no completed proof is identified; a module may merely state or
  assume the target.
- **Review required:** upstream commit differs from the reviewed commit;
  counts are refreshed, but the prior status is not promoted or inherited.
- **Unavailable:** retrieval or mapping failed; no count is asserted.

For each project, the registry records the reviewed revision, scope, evidence
path, and explicit selected module paths for each cell. These initial review
judgments are AI-assisted, not independent kernel validation or expert
certification. Do not assign complete just because a file contains a theorem
with a promising name, has no `sorry`, or reports a green build. There is no
claimed exact all-group ym-lean proof among the initial registry entries.

## Maintain the registry

To add a framework, add its repository, tracked ref, exact reviewed commit,
scope and evidence, package roots/include globs, and one cell per subproof.
A cell has a status, zero or more exact repo-relative Lean module paths,
and an optional explanatory note. Non-open cells must have selected roots.
For an updated revision, inspect the actual theorem statements and
hypotheses, verify any supplied build/axiom evidence, adjust the roots and
statuses, and only then update `reviewed_revision`. The source census
never changes a mathematical status automatically.

Run the regression tests and the reviewed replay before merging a registry
change. A report remains available if any individual source fails; CI fails
rather than concealing a missing project.

For exact acceptance of a translated or submitted proof, continue to use
the existing verifier with the appropriate `--claim`. The comparative
chart does not alter the theorem target, source inventory, or acceptance
policy.
