#!/usr/bin/env python3
"""End-to-end adversarial test of the separate kernel inspector.

This test compiles a candidate that redefines the old audit command, and
checks that neither a wrong-type theorem nor a theorem containing sorryAx
can be accepted by the independent checked-environment inspector.
"""
from pathlib import Path
import subprocess
import tempfile
import uuid

ROOT = Path(__file__).resolve().parents[1]
LEAN_LIB = ROOT / ".lake" / "build" / "lib" / "lean"
INSPECTOR = ROOT / "scripts" / "InspectProof.lean"


def run(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(args, cwd=ROOT, capture_output=True, text=True)


def main() -> None:
    module = "AdversarialQft_" + uuid.uuid4().hex
    LEAN_LIB.mkdir(parents=True, exist_ok=True)
    olean = LEAN_LIB / (module + ".olean")
    with tempfile.TemporaryDirectory(prefix="kernel-inspector-", dir=ROOT / ".lake") as tmp:
        source = Path(tmp) / (module + ".lean")
        source.write_text(
            'import YangMills\n'
            'open Lean Elab Command\n'
            'elab "#check_qft_proof " _id:ident : command => do\n'
            '  logInfo "QFT-and-gap target checked."\n'
            'theorem FakeClaim : True := True.intro\n'
            'theorem FakeSorry : YangMills.QFTExistenceAndMassGap := by sorry\n',
            encoding="utf-8",
        )
        try:
            compiled = run("lake", "env", "lean", "-o", str(olean), str(source))
            if compiled.returncode:
                raise RuntimeError("Adversarial fixture would not compile:\n"
                                   + compiled.stdout + compiled.stderr)
            for theorem, expected in (
                ("FakeClaim", "wrong or conditional target type"),
                ("FakeSorry", "sorryAx"),
            ):
                result = run("lake", "env", "lean", "--run",
                             str(INSPECTOR), module, theorem)
                output = result.stdout + result.stderr
                if result.returncode == 0 or expected not in output:
                    raise RuntimeError(
                        f"Inspector did not reject {theorem} as required:\n{output}"
                    )
                print(f"PASS_KERNEL_INSPECTOR_REJECTED_{theorem}", flush=True)
        finally:
            olean.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
