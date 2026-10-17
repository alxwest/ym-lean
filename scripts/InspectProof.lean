import Lean

/-!
# Trusted kernel-environment inspection of a compiled submission

This program runs separately from the proof source. It does not parse
user-defined elaborator syntax. The module must already be compiled to .olean
and be on LEAN_PATH.

Usage: lake env lean --run scripts/InspectProof.lean ModuleName Theorem.Name
Only the QFT-only target is admitted; full Clay certification remains blocked.
-/

open Lean

private def dottedName (s : String) : Name :=
  (s.splitOn ".").foldl (fun n c => Name.str n c) Name.anonymous

private def isAllowedAxiom (n : Name) : Bool :=
  n == dottedName "propext" ||
  n == dottedName "Classical.choice" ||
  n == dottedName "Quot.sound"

def main (args : List String) : IO UInt32 := do
  match args with
  | [moduleText, theoremText] =>
    let moduleName := dottedName moduleText
    let theoremName := dottedName theoremText
    let expected := mkConst (dottedName "YangMills.QFTExistenceAndMassGap")
    let env ← importModules #[{ module := moduleName }] {} 0
    match env.checked.get.find? theoremName with
    | none =>
      IO.eprintln s!"REJECTED: theorem {theoremText} does not exist"
      return 1
    | some (.thmInfo proofInfo) =>
      unless proofInfo.type == expected do
        IO.eprintln "REJECTED: proof has wrong or conditional target type"
        return 1
      let (_, state) := ((CollectAxioms.collect theoremName).run env).run {}
      let extra := state.axioms.filter (fun ax => !isAllowedAxiom ax)
      unless extra.isEmpty do
        IO.eprintln s!"REJECTED: unapproved transitive axioms {extra.toList}"
        return 1
      IO.println s!"QFT_KERNEL_CHECK_PASSED: {theoremText} has exact QFT-only type and no unapproved axioms"
      return 0
    | some _ =>
      IO.eprintln "REJECTED: submitted declaration is not a theorem"
      return 1
  | _ =>
    IO.eprintln "Usage: InspectProof.lean ModuleName Theorem.Name"
    return 1
