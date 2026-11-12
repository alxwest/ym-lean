#!/usr/bin/env python3
"""Real source-translation acceptance and negative controls.

Run scripts/translate_ym_ymg.sh first to build the optional sibling integration.
These checks use the actual source theorem, not a fake existence oracle as a
positive fixture. Deliberate bad axioms occur only in temporary negative tests.
"""
import os
from pathlib import Path
import subprocess
import tempfile
import uuid

ROOT = Path(__file__).resolve().parents[1]
STAGE = ROOT / '.lake' / 'ym-ymg-integration'
PACKAGES = ROOT / '.lake' / 'ym-ymg-packages.json'


def main():
    with tempfile.TemporaryDirectory(prefix='ym-ymg-translation-') as tmp:
        directory = Path(tmp)
        env = os.environ.copy()
        # lake env will add the staged dependency paths to this fixture path.
        env['LEAN_PATH'] = str(directory) + os.pathsep + env.get('LEAN_PATH', '')

        def run(*args):
            return subprocess.run(
                ['lake', '-d', str(STAGE), '--packages=' + str(PACKAGES),
                 'env', 'lean', *map(str, args)], cwd=ROOT, env=env,
                capture_output=True, text=True, timeout=1200)

        def inspect(module, theorem):
            return run('--run', ROOT / 'scripts' / 'InspectYMGTranslation.lean', module, theorem)

        positive = inspect('YMGBridge.Solution', 'YMGBridge.jointExistence')
        if positive.returncode or 'SOURCE_TRANSLATION_CHECKED:' not in positive.stdout:
            raise RuntimeError(positive.stdout + positive.stderr)
        print('PASS_ACTUAL_SOURCE_TRANSLATION', flush=True)

        module = 'TranslationNegative_' + uuid.uuid4().hex
        source = directory / (module + '.lean')
        source.write_text('''import YMGBridge.Solution
open Lean Elab Command
-- Test both directions at a genuinely higher carrier universe.
example : YMGBridge.PresentedJointExistence.{2} := YMGBridge.jointExistence
theorem recoveredSource : YMGSubmission.JointExistence :=
  YMGBridge.presentedJointExistence_iff_source.{2}.mp YMGBridge.jointExistence
theorem fixed : YMGBridge.PresentedJointExistence.{0} := YMGBridge.jointExistence
theorem conditional.{u} (h : YMGBridge.PresentedJointExistence.{u}) :
    YMGBridge.PresentedJointExistence.{u} := h
axiom badOracle.{u} : YMGBridge.PresentedJointExistence.{u}
theorem badAxiom.{u} : YMGBridge.PresentedJointExistence.{u} := badOracle
set_option linter.defProp false in
def notTheorem.{u} : YMGBridge.PresentedJointExistence.{u} := YMGBridge.jointExistence
theorem differentTarget.{u} : ∀ X : Type u, Nonempty X → Nonempty X := fun _ h => h
run_cmd liftCoreM <| addDecl (.thmDecl { name := `unusedUniverse, levelParams := [`u], type := mkConst `YMGBridge.PresentedJointExistence [.zero], value := mkConst `fixed })
run_cmd liftCoreM <| addDecl (.thmDecl { name := `extraUniverses, levelParams := [`u, `v], type := mkConst `YMGBridge.PresentedJointExistence [.param `u], value := mkConst `YMGBridge.jointExistence [.param `u] })
''')
        compiled = run('--root=' + str(directory), '-o', directory / (module + '.olean'), source)
        if compiled.returncode:
            raise RuntimeError(compiled.stdout + compiled.stderr)
        print('PASS_HIGHER_UNIVERSE_AND_ROUND_TRIP', flush=True)
        for theorem, marker in (
            ('fixed', 'one universe parameter'),
            ('conditional', 'conditional target type'),
            ('badAxiom', 'badOracle'),
            ('badOracle', 'not a theorem'),
            ('notTheorem', 'not a theorem'),
            ('differentTarget', 'conditional target type'),
            ('unusedUniverse', 'fixed-universe'),
            ('extraUniverses', 'one universe parameter'),
        ):
            result = inspect(module, theorem)
            if result.returncode != 1 or marker not in result.stderr:
                raise RuntimeError(f'Incorrect acceptance/rejection of {theorem}:\n' +
                                   result.stdout + result.stderr)
            print('PASS_SOURCE_TRANSLATION_REJECTED_' + theorem, flush=True)


if __name__ == '__main__':
    main()
