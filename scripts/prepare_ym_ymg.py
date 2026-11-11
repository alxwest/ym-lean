#!/usr/bin/env python3
"""Reuse matching local dependencies without changing ym-ymg's pinned manifest."""
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def write_if_changed(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists() or path.read_text() != content:
        path.write_text(content)


def stage_wrappers(submission: Path, overrides: list[dict], version: str) -> Path:
    """Alpha-rename only the public wrapper import closure; keep YM sources upstream."""
    stage = ROOT / ".lake" / "ym-ymg-integration"
    sources = {}
    pending = ["Solution"]
    while pending:
        module = pending.pop()
        if module in sources:
            continue
        source = (submission / f"{module}.lean").read_text()
        sources[module] = source
        for line in source.splitlines():
            if line.startswith("import "):
                pending.extend(name for name in line.split()[1:]
                               if "." not in name and (submission / f"{name}.lean").is_file())
    for module, source in sources.items():
        def rename_import(match):
            names = match.group(1).split()
            return "import " + " ".join(
                f"YMGSubmission.{name}" if name in sources else name for name in names)
        renamed = re.sub(r"^import ([^\n]+)$", rename_import, source, flags=re.MULTILINE)
        renamed = re.sub(r"\bYangMills\b", "YMGSubmission", renamed)
        write_if_changed(stage / "YMGSubmission" / f"{module}.lean", renamed)
    write_if_changed(stage / "lean-toolchain", (submission / "lean-toolchain").read_text())
    write_if_changed(stage / "lakefile.toml", '\n'.join([
        'name = "ym_ymg_integration"', '[leanOptions]', 'maxHeartbeats = 0',
        'maxRecDepth = 4096', '[[require]]', 'name = "ym_core"',
        f'path = {json.dumps(str(submission))}', '[[lean_lib]]',
        'name = "YMGSubmission"', '',
    ]))
    dependency = dict(name="ym_core", scope="", type="path", dir=str(submission),
                      inherited=False, configFile="lakefile.toml", manifestFile="lake-manifest.json")
    manifest = dict(version=version, name="ym_ymg_integration", lakeDir=".lake",
                    packagesDir=".lake/packages", packages=[dependency, *overrides])
    write_if_changed(stage / "lake-manifest.json", json.dumps(manifest, indent=2) + "\n")
    return stage


def prepare(submission: Path) -> Path:
    submission = submission.resolve()
    for name in ("Construction.lean", "Solution.lean", "lean-toolchain", "lake-manifest.json"):
        if not (submission / name).is_file():
            raise ValueError(f"Missing submission file: {submission / name}")
    if (ROOT / "lean-toolchain").read_text().strip() != (submission / "lean-toolchain").read_text().strip():
        raise ValueError("ym-lean and ym-ymg must use the same Lean toolchain")
    local = json.loads((ROOT / "lake-manifest.json").read_text())
    remote = json.loads((submission / "lake-manifest.json").read_text())
    available = {entry["name"]: entry for entry in local["packages"]}
    overrides = []
    for entry in remote["packages"]:
        name = entry["name"]
        ours = available.get(name, {})
        if any(entry.get(key) != ours.get(key) for key in ("type", "url", "rev", "subDir")):
            raise ValueError(f"Dependency pins differ for {name}; cannot share its build cache")
        package = ROOT / local["packagesDir"] / name
        revision = subprocess.check_output(
            ["git", "-C", str(package), "rev-parse", "HEAD"], text=True).strip()
        if revision != entry["rev"]:
            raise ValueError(f"Local {name} checkout does not match its pinned revision")
        dirty = subprocess.check_output(
            ["git", "-C", str(package), "status", "--porcelain", "--untracked-files=no"], text=True)
        if dirty:
            raise ValueError(f"Local {name} has tracked changes; cannot share its build cache")
        overrides.append({
            "name": name, "scope": entry.get("scope", ""), "type": "path",
            "dir": str(package.resolve()), "inherited": entry["inherited"],
            "configFile": entry["configFile"], "manifestFile": entry["manifestFile"],
        })
    output = ROOT / ".lake" / "ym-ymg-packages.json"
    output.parent.mkdir(exist_ok=True)
    write_if_changed(output, json.dumps({"version": local["version"], "packages": overrides}, indent=2) + "\n")
    stage_wrappers(submission, overrides, local["version"])
    return output


if __name__ == "__main__":
    try:
        print(prepare(Path(sys.argv[1])))
    except (IndexError, OSError, ValueError, subprocess.CalledProcessError) as exc:
        sys.exit(f"ym-ymg setup failed: {exc}")
