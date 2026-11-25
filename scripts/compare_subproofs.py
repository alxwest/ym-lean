#!/usr/bin/env python3
"""Revision-pinned, read-only Lean source census; never a proof verifier."""
from __future__ import annotations

import argparse
import base64
import concurrent.futures
import csv
import fnmatch
import hashlib
import html
import json
import os
from pathlib import Path, PurePosixPath
import re
import subprocess
import tempfile
from collections import Counter
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
STATES = {"complete", "partial", "conditional", "open"}
COLORS = {"complete": "#15803d", "partial": "#b77900", "conditional": "#9333ea"}
EXCLUDE = {"vendor", ".lake", ".git", "tests", "test", "checks", "audit",
           "attempts", "probes", ".shipping_backups", "massgapchecks", "scripts"}
TOKEN = re.compile(r'/-|-/|--|"(?:\\.|[^"\\])*"')
DECL = re.compile(
    r"(?m)^[ \t]*(?:(?:@\[[^\n]*?\])\s*|"
    r"(?:private|protected|noncomputable|unsafe|partial|scoped|local|nonrec|meta)\s+)*"
    r"(theorem|lemma|def|abbrev|structure|class|inductive|coinductive|opaque|axiom|instance)"
    r"\s+(?=[^\s:({\[])")
IMPORT = re.compile(r"(?m)^[ \t]*(?:(?:public|private|meta)\s+)*import[ \t]+([^\n]+)")
SHA = re.compile(r"[0-9a-f]{40}\Z")
REPO = re.compile(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+\Z")
IDENT = re.compile(r"[A-Za-z0-9][A-Za-z0-9_.-]*\Z")
REF = re.compile(r"refs/heads/[A-Za-z0-9_./-]+\Z")


def clean(source: str) -> str:
    """Remove nested block/line comments and ordinary strings; preserve newlines.

    A lexical count, not a full Lean parser. In particular it excludes
    elaborator-generated declarations and anonymous instances.
    """
    chunks = []
    pos = 0
    depth = 0
    while pos < len(source):
        if depth:
            # Search only comment delimiters while inside a nested comment.
            hit = BLOCK.search(source, pos)
            end = hit.end() if hit else len(source)
            chunks.append("\n" * source.count("\n", pos, end))
            if hit:
                depth += 1 if hit.group() == "/-" else -1
            pos = end
        else:
            hit = TOKEN.search(source, pos)
            if not hit:
                chunks.append(source[pos:])
                break
            chunks.append(source[pos:hit.start()])
            token = hit.group()
            if token == "/-":
                chunks.append(" ")
                depth = 1
                pos = hit.end()
            elif token == "--":
                end = source.find("\n", hit.end())
                pos = len(source) if end == -1 else end
                chunks.append(" ")
            elif token.startswith('"'):
                chunks.append('""' + "\n" * token.count("\n"))
                pos = hit.end()
            else:
                chunks.append(token)
                pos = hit.end()
    return "".join(chunks)


BLOCK = re.compile(r"/-|-/")


def run_git(*args: str, cwd: Path | None = None, timeout: int = 600,
            auth: tuple[str, str] | None = None) -> str:
    # Public sources only. Do not inherit local helpers/hooks/configuration.
    env = {k: v for k, v in os.environ.items()
           if not k.startswith(("GIT_CONFIG", "GIT_TRACE", "GIT_CURL_VERBOSE"))
           and k != "YM_SUBPROOF_DYADIC_TOKEN"}
    env.update(GIT_TERMINAL_PROMPT="0", GIT_CONFIG_NOSYSTEM="1",
               GIT_CONFIG_GLOBAL=os.devnull, GIT_OPTIONAL_LOCKS="0",
               GIT_LFS_SKIP_SMUDGE="1")
    if auth:
        repo, token = auth
        encoded = base64.b64encode(f"x-access-token:{token}".encode()).decode()
        # Pass the credential in process environment, never URL, argv or logs.
        # Scope it to this one repository, including lazy blob fetches.
        env.update(GIT_CONFIG_COUNT="1",
                   GIT_CONFIG_KEY_0=f"http.https://github.com/{repo}.git.extraheader",
                   GIT_CONFIG_VALUE_0=f"Authorization: Basic {encoded}")
    return subprocess.run(
        ["git", "-c", "core.hooksPath=" + os.devnull,
         "-c", "protocol.file.allow=never", *args],
        cwd=cwd, env=env, check=True, capture_output=True, text=True,
        timeout=timeout, encoding="utf-8", errors="replace").stdout


def safe_path(s: str) -> bool:
    p = PurePosixPath(s)
    return bool(s) and not p.is_absolute() and ".." not in p.parts and "\\" not in s


def validate(registry: dict, requirements: dict) -> None:
    if registry.get("schema_version") != 1:
        raise ValueError("Unsupported registry schema")
    ids = {x["id"] for x in requirements["requirements"]}
    areas = registry["areas"]
    keys = [a["id"] for a in areas]
    if not keys or len(keys) != len(set(keys)):
        raise ValueError("Duplicate or missing subproof IDs")
    covered = set()
    for a in areas:
        if not IDENT.fullmatch(a["id"]) or not a["requirement_ids"] or not set(a["requirement_ids"]) <= ids:
            raise ValueError(f"Unknown requirement mapping: {a}")
        covered.update(a["requirement_ids"])
    if covered != ids:
        raise ValueError("Subproof map must cover all source requirements")
    seen = set()
    seen_repos = set()
    for p in registry["projects"]:
        if (not IDENT.fullmatch(p["id"]) or p["id"] in seen
                or not REPO.fullmatch(p["repository"]) or p["repository"] in seen_repos
                or not SHA.fullmatch(p["reviewed_revision"])
                or not (p["ref"] == "HEAD" or REF.fullmatch(p["ref"]))
                or not safe_path(p["review_evidence"]) or not p["scope"]):
            raise ValueError(f"Invalid or duplicate project: {p['id']}")
        if p.get("private_source") and p["repository"] != "alxwest/ym":
            raise ValueError("Private token is restricted to alxwest/ym")
        seen.add(p["id"])
        seen_repos.add(p["repository"])
        if set(p["cells"]) != set(keys):
            raise ValueError(f"Incomplete cell map: {p['id']}")
        for c in p["cells"].values():
            if (c["status"] not in STATES
                    or (c["status"] != "open" and not c["roots"])
                    or len(c["roots"]) != len(set(c["roots"]))
                    or any(not safe_path(r) or not r.endswith(".lean") for r in c["roots"])):
                raise ValueError(f"Invalid cell: {p['id']} {c}")
        for pkg in p["packages"]:
            if not safe_path(pkg["root"]) or not pkg["include"] or any(not safe_path(x) for x in pkg["include"]):
                raise ValueError(f"Invalid package: {p['id']} {pkg}")


def matches(rel: str, pat: str) -> bool:
    # '**/' permits zero directory components, unlike fnmatch on its own.
    return fnmatch.fnmatchcase(rel, pat) or ("**/" in pat and matches(rel, pat.replace("**/", "", 1)))


def inventory(project: dict, directory: Path, revision: str) -> tuple[dict, dict, list]:
    """Only tracked project sources, keyed by repo-relative paths, not filenames."""
    tracked = run_git("ls-tree", "-r", "--name-only", "-z", revision, cwd=directory).split("\0")
    files, modules, problems = {}, {}, []
    for rel in sorted(tracked):
        if not rel.endswith(".lean") or not safe_path(rel):
            continue
        if any(x.lower() in EXCLUDE for x in PurePosixPath(rel).parts):
            continue
        for package in project["packages"]:
            try:
                within = PurePosixPath(rel).relative_to(PurePosixPath(package["root"])).as_posix()
            except ValueError:
                continue
            if not any(matches(within, pat) for pat in package["include"]):
                continue
            # The published SolidSF campaign contains unrelated/reward-hacked
            # material; keep only the explicitly selected Wilson physics corpus.
            if project["id"] == "SolidSF" and rel.startswith("JesseMath/Physics/"):
                if not (PurePosixPath(rel).stem.startswith("YangMills")
                        or PurePosixPath(rel).stem in {"LatticeYangMills", "HaarPairDisintegration", "ConstructiveYangMills"}):
                    continue
            path = directory / rel
            if path.is_symlink() or not path.is_file() or directory.resolve() not in path.resolve().parents:
                problems.append(f"Missing or unsafe tracked source: {rel}")
                continue
            if rel in files:
                problems.append(f"Overlapping package selection: {rel}")
                continue
            module = ".".join(PurePosixPath(within).with_suffix("").parts)
            txt = clean(path.read_text(encoding="utf-8", errors="replace"))
            kinds = Counter(DECL.findall(txt))
            imports = sorted({x for line in IMPORT.findall(txt) for x in line.split()
                              if x and not x.startswith("--")})
            files[rel] = {"module": module, "declarations": sum(kinds.values()),
                          "kinds": dict(kinds), "imports": imports,
                          "sorry_tokens": len(re.findall(r"\b(?:sorry|admit)\b", txt))}
            modules.setdefault(module, []).append(rel)
    if not files:
        problems.append("No selected Lean source files")
    return files, modules, problems


def closure(roots: list, files: dict, modules: dict) -> tuple[set, set, set]:
    visited, outside, problems = set(), set(), set()
    todo = list(roots)
    while todo:
        path = todo.pop()
        if path in visited:
            continue
        if path not in files:
            problems.add(f"Missing root: {path}")
            continue
        visited.add(path)
        for mod in files[path]["imports"]:
            hits = modules.get(mod, [])
            if not hits:
                outside.add(mod)
            elif len(hits) > 1:
                problems.add(f"Ambiguous project import: {mod}")
            else:
                todo.extend(hits)
    return visited, outside, problems


def prepare(project: dict, base: Path, mode: str, local: bool) -> tuple[Path, str]:
    directory = base / project["id"]
    if local:
        # Local testing must use a clean committed checkout; don't execute its code.
        revision = run_git("rev-parse", "HEAD", cwd=directory).strip()
        run_git("diff", "--quiet", "HEAD", "--", cwd=directory)
    else:
        auth = None
        if project.get("private_source"):
            token = os.environ.get("YM_SUBPROOF_DYADIC_TOKEN")
            if not token:
                raise PermissionError("Private source disabled: configure YM_SUBPROOF_DYADIC_TOKEN to opt into public aggregate reporting")
            auth = (project["repository"], token)
        directory.mkdir()
        run_git("init", "-q", cwd=directory)
        run_git("remote", "add", "origin", f"https://github.com/{project['repository']}.git", cwd=directory)
        ref = project["reviewed_revision"] if mode == "reviewed" else project["ref"]
        run_git("fetch", "--depth=1", "--filter=blob:none", "--no-tags", "origin", ref, cwd=directory, auth=auth)
        revision = run_git("rev-parse", "FETCH_HEAD", cwd=directory).strip()
        roots = sorted({p["root"] for p in project["packages"]})
        if "." not in roots:
            run_git("sparse-checkout", "init", "--cone", cwd=directory, auth=auth)
            run_git("sparse-checkout", "set", "--", *roots, cwd=directory, auth=auth)
        run_git("checkout", "--detach", revision, cwd=directory, auth=auth)
    if not SHA.fullmatch(revision):
        raise ValueError("Invalid resolved revision")
    if mode == "reviewed" and revision != project["reviewed_revision"]:
        raise ValueError(f"Expected reviewed revision {project['reviewed_revision']}, got {revision}")
    return directory, revision


def analyze(project: dict, base: Path, mode: str, local: bool) -> dict:
    result = {k: project[k] for k in ("id", "label", "repository", "ref", "scope",
                                     "reviewed_revision", "reviewed_on", "review_evidence")}
    result.update(revision=None, total_declarations=None, total_modules=None, union_declarations=None,
                  cells={}, errors=[])
    try:
        directory, revision = prepare(project, base, mode, local)
        result["revision"] = revision
        files, modules, problems = inventory(project, directory, revision)
        result["errors"].extend(problems)
        result["total_declarations"] = sum(f["declarations"] for f in files.values())
        result["total_modules"] = len(files)
        result["source_inventory"] = files
        union = set()
        for area, c in project["cells"].items():
            roots = c["roots"]
            seen, outside, issues = closure(roots, files, modules)
            union.update(seen)
            result["errors"].extend(f"{area}: {i}" for i in sorted(issues))
            # Mathematical classification and data availability are independent.
            # Counts can be refreshed without silently changing the assessed status.
            count_status = "unavailable" if issues or problems else "counted" if roots else "not-mapped"
            result["cells"][area] = {
                "status": c["status"], "reviewed_status": c["status"], "count_status": count_status, "roots": roots,
                "note": c.get("note", ""),
                "declarations": sum(files[f]["declarations"] for f in seen) if roots and not issues and not problems else None,
                "root_declarations": sum(files[f]["declarations"] for f in roots if f in files) if roots and not issues and not problems else None,
                "module_count": len(seen), "closure_files": sorted(seen),
                "outside_selected_imports": sorted(outside),
                "axiom_declarations": sum(files[f]["kinds"].get("axiom", 0) for f in seen),
                "sorry_tokens": sum(files[f]["sorry_tokens"] for f in seen),
                "problems": sorted(issues),
            }
        result["union_declarations"] = sum(files[f]["declarations"] for f in union)
    except (OSError, ValueError, subprocess.SubprocessError) as exc:
        result["errors"].append(f"{type(exc).__name__}: {str(exc)[:600]}")
    for area, c in project["cells"].items():
        if area not in result["cells"]:
            result["cells"][area] = {"status": c["status"], "reviewed_status": c["status"], "count_status": "unavailable",
                                     "roots": c["roots"], "declarations": None, "note": c.get("note", ""),
                                     "module_count": None}
    if project.get("private_source"):
        # Public ym-lean artifacts may contain aggregate counts and reviewed
        # statuses, never private source files, the full path inventory or
        # dependency names. The registry supplies the selected anchor paths.
        result["private_source"] = True
        result.pop("source_inventory", None)
        if result["errors"] and not any("Private source disabled:" in e for e in result["errors"]):
            result["errors"] = ["Private source census incomplete; check repository access and configured anchors."]
        for cell in result["cells"].values():
            cell["root_count"] = len(cell["roots"])
            cell["roots"] = []
            cell.pop("closure_files", None)
            cell.pop("outside_selected_imports", None)
            cell.pop("problems", None)
    return result


def write_csv(report: dict, out: Path) -> None:
    keys = ["framework", "repository", "revision", "reviewed_revision", "subproof", "status",
            "reviewed_status", "count_status", "declarations", "root_declarations", "module_count", "root_count",
            "axiom_declarations", "sorry_tokens", "roots", "scope", "note"]
    with (out / "subproofs.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=keys)
        w.writeheader()
        for p in report["projects"]:
            for a in report["areas"]:
                c = p["cells"][a["id"]]
                w.writerow({**{k: p[k] for k in ("repository", "revision", "reviewed_revision", "scope")},
                            **{k: c.get(k) for k in keys if k in c and k != "roots"},
                            "framework": p["label"], "subproof": a["id"], "roots": ";".join(c["roots"])})


def write_svg(report: dict, out: Path) -> None:
    areas, projects = report["areas"], report["projects"]
    left, col, row, top = 195, 116, 35, 120
    width, height = left + len(areas)*col + 15, top + len(projects)*row + 55
    esc = lambda x: html.escape(str(x), quote=True)
    svg = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img" aria-labelledby="title desc">',
           '<title id="title">Lean declaration count by Yang–Mills subproof</title>',
           '<desc id="desc">All frameworks and all subproofs. Independent linear scale per column. Blank cells are open. Source closure counts are not proof certification.</desc>',
           f'<rect width="{width}" height="{height}" fill="#fff"/>',
           '<g font-family="system-ui, sans-serif" fill="#172033">',
           '<text x="14" y="24" font-size="19" font-weight="700">Yang–Mills · Lean declaration count by subproof</text>',
           '<text x="14" y="43" font-size="11" fill="#475569">Named source declarations in selected module import closures · linear scales per column · not a kernel proof certificate</text>']
    for i, (status, color) in enumerate(COLORS.items()):
        x = 14+i*155
        svg += [f'<circle cx="{x+5}" cy="62" r="5" fill="{color}"/>',
                f'<text x="{x+15}" y="66" font-size="11">{esc(status)}</text>']
    svg.append('<text x="479" y="66" font-size="11">Blank = open</text>')
    # Scale only against visible bars; hidden open scaffolds must not
    # compress the completed, partial and conditional counts.
    maxs = [max((p["cells"][a["id"]]["declarations"] or 0 for p in projects
                 if p["cells"][a["id"]]["status"] != "open"), default=0) for a in areas]
    for j, a in enumerate(areas):
        x = left+j*col
        words = a["label"].split()
        lines = [""]
        for word in words:
            if len(lines[-1]) + len(word) > 18 and lines[-1]:
                lines.append(word)
            else:
                lines[-1] = (lines[-1] + " " + word).strip()
        for k, line in enumerate(lines):
            svg.append(f'<text x="{x+col/2}" y="{80+k*12}" text-anchor="middle" font-size="10.5" font-weight="600">{esc(line)}</text>')
        if maxs[j]:
            svg.append(f'<text x="{x+col/2}" y="113" font-size="9" text-anchor="middle" fill="#64748b">0–{maxs[j]:,}</text>')
    for i, p in enumerate(projects):
        y = top+i*row
        if i%2 == 0:
            svg.append(f'<rect x="4" y="{y}" width="{width-8}" height="{row}" fill="#f1f5f9"/>')
        label = p["label"]
        rev = (p["revision"] or "unavailable")[:10]
        svg.append(f'<text x="14" y="{y+15}" font-size="12" font-weight="600">{esc(label)}</text>')
        svg.append(f'<text x="14" y="{y+28}" font-size="9" fill="#64748b">{esc(rev)}</text>')
        for j, a in enumerate(areas):
            c = p["cells"][a["id"]]
            if c["status"] == "open":
                continue
            x = left+j*col
            value = c["declarations"]
            color = COLORS[c["status"]]
            svg.append(f'<g><title>{esc(label)} · {esc(a["label"])} · {esc(c["status"])} · {esc(value if value is not None else "not counted")} · count: {esc(c.get("count_status", "not-mapped"))} · status revision: {esc(p.get("reviewed_revision", "unspecified"))} · {esc(c.get("note", ""))}</title>')
            svg.append(f'<circle cx="{x+9}" cy="{y+13}" r="4" fill="{color}"/>')
            display = f"{value:,}" if value is not None else "n/a" if c.get("count_status") == "unavailable" else "—"
            svg.append(f'<text x="{x+col-9}" y="{y+17}" text-anchor="end" font-size="11.5">{display}</text>')
            svg.append(f'<rect x="{x+5}" y="{y+22}" width="{col-12}" height="5" rx="2" fill="#e2e8f0"/>')
            if value:
                svg.append(f'<rect x="{x+5}" y="{y+22}" width="{(col-12)*value/maxs[j]:.4f}" height="5" rx="2" fill="{color}"/>')
            svg.append('</g>')
    svg += [f'<text x="14" y="{height-27}" font-size="11" fill="#475569">Blank = open; n/a = count unavailable; all underlying counts are retained in CSV/JSON. Shared imports can recur.</text>',
            f'<text x="14" y="{height-12}" font-size="11" fill="#475569">Colours show the last assessed proof status; counts use the displayed source revision. Assessment revisions are recorded in report.md and report.json.</text>',
            '</g></svg>']
    (out / "subproof-chart.svg").write_text("\n".join(svg), encoding="utf-8")


def markdown(report: dict) -> str:
    lines = ["# Lean subproof comparison", "",
             f"Snapshot mode: **{report['mode']}** · Reference: `{report['reference_revision']}`", "",
             "Counts are named source declarations in selected project-local import closures, not exact theorem dependencies. Colours show the last assessed proof status, not a fresh kernel or Clay verdict. Counts use the fetched revision; the status assessment revision is recorded separately. Shared dependencies may recur. Blank subproof cells mean open; n/a means count unavailable. Open-cell counts remain in CSV/JSON.", "",
             "| Framework | Source modules | Source declarations | Union of selected closures | Count revision | Status revision | Count data |",
             "|---|---:|---:|---:|---|---|---|"]
    def f(n):
        return "—" if n is None else f"{n:,}"
    for p in report["projects"]:
        rev = p["revision"]
        link = f"[{rev[:10]}](https://github.com/{p['repository']}/tree/{rev})" if rev else "unavailable"
        assessed = p["reviewed_revision"]
        assessment_link = f"[{assessed[:10]}](https://github.com/{p['repository']}/tree/{assessed})"
        count_data = "errors" if p["errors"] else "available"
        lines.append(f"| {p['label']} | {f(p['total_modules'])} | {f(p['total_declarations'])} | {f(p['union_declarations'])} | {link} | {assessment_link} | {count_data} |")
    icons = {"complete": "🟢", "partial": "🟡", "conditional": "🟣"}
    for first, last in [(0,6), (6,13), (13,len(report["areas"]))]:
        aa = report["areas"][first:last]
        if not aa:
            continue
        lines += ["", "| Framework | " + " | ".join(a["label"] for a in aa) + " |",
                  "|---|" + "---:|"*len(aa)]
        for p in report["projects"]:
            cells = [p["cells"][a["id"]] for a in aa]
            def cell_text(c):
                if c["status"] == "open":
                    return ""
                value = "n/a" if c.get("count_status") == "unavailable" else f(c["declarations"])
                return f"{icons[c['status']]} {value}"
            lines.append("| " + p["label"] + " | " + " | ".join(cell_text(c) for c in cells) + " |")
    lines += ["", "## Specification crosswalk", "", "| Subproof | source/requirements.json IDs |", "|---|---|"]
    for a in report["areas"]:
        lines.append(f"| {a['label']} | {', '.join(a['requirement_ids'])} |")
    lines += ["", "## Scope and review evidence", "",
              "🟢 Complete · 🟡 Partial · 🟣 Conditional · Blank = open", ""]
    for p in report["projects"]:
        link = f"https://github.com/{p['repository']}/blob/{p['reviewed_revision']}/{p['review_evidence']}"
        lines.append(f"- **{p['label']}**: {p['scope']} [Reviewed evidence]({link}).")
        for a in report["areas"]:
            c = p["cells"][a["id"]]
            if c.get("note"):
                lines.append(f"  - {a['label']}: {c['note']}")
        if p.get("private_source"):
            lines.append("  - Private source: aggregate counts only; detailed dependency inventory withheld.")
        if p["errors"]:
            lines.extend(f"  - Error: {e}" for e in p["errors"])
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mode", choices=["latest", "reviewed"], default="latest")
    parser.add_argument("--output", type=Path, default=Path("subproof-report"))
    parser.add_argument("--registry", type=Path, default=ROOT/"source/subproofs/registry.json")
    parser.add_argument("--local-sources", type=Path, help="Use clean checkouts named by registry ID (offline testing).")
    parser.add_argument("--workers", type=int, default=4)
    args = parser.parse_args()
    registry = json.loads(args.registry.read_text())
    requirements = json.loads((ROOT/"source/requirements.json").read_text())
    validate(registry, requirements)
    if args.workers < 1 or args.workers > 8:
        parser.error("--workers must be between 1 and 8")
    with tempfile.TemporaryDirectory(prefix="ym-subproof-") as temp:
        base = args.local_sources.resolve() if args.local_sources else Path(temp)
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
            futures = [pool.submit(analyze, p, base, args.mode, bool(args.local_sources)) for p in registry["projects"]]
            projects = []
            for future in futures:
                p = future.result()
                projects.append(p)
                print(f"{p['id']}: {p['total_declarations']} declarations; {len(p['errors'])} error(s)", flush=True)
    report = {"schema_version": 1, "mode": args.mode, "generated_at": datetime.now(timezone.utc).isoformat(),
              "reference_revision": run_git("rev-parse", "HEAD", cwd=ROOT).strip(),
              "registry_sha256": hashlib.sha256(args.registry.read_bytes()).hexdigest(),
              "requirements_sha256": hashlib.sha256((ROOT/"source/requirements.json").read_bytes()).hexdigest(),
              "areas": registry["areas"], "projects": projects}
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output/"report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2)+"\n", encoding="utf-8")
    (args.output/"report.md").write_text(markdown(report), encoding="utf-8")
    write_csv(report, args.output)
    write_svg(report, args.output)
    return int(any(p["errors"] for p in projects))


if __name__ == "__main__":
    raise SystemExit(main())
