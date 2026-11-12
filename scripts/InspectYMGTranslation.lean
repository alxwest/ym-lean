import Lean

/-! Inspect the source translation in a separate process, without executing
submitted audit syntax. Passing this check is NOT admission to ym-lean's
YangMillsExistenceOnly target. The translation definition is staged from this
repository; its source predicates retain the submission's definitions. -/
open Lean

private def dottedName (s : String) : Name :=
  (s.splitOn ".").foldl (fun n c => Name.str n c) Name.anonymous

private def target := dottedName "YMGBridge.PresentedJointExistence"

private def allowed (n : Name) : Bool :=
  n == dottedName "propext" || n == dottedName "Classical.choice" ||
    n == dottedName "Quot.sound"

private def checkShape (env : Environment) : Except String Unit := do
  let some (.defnInfo info) := env.checked.get.find? target
    | throw "source translation target is absent or not a definition"
  let [u] := info.levelParams | throw "translation target must have one universe parameter"
  unless info.type == mkSort .zero do throw "translation target is not a closed Prop"
  let .forallE _ group body _ := info.value.consumeMData
    | throw "translation target does not quantify the presented group"
  unless group == mkConst (dottedName "YMGBridge.PresentedGaugeGroup") [.param u] do
    throw "wrong presented-group type/universe"
  let matrix := mkApp
    (mkConst (dottedName "YMGBridge.PresentedGaugeGroup.matrix") [.param u]) (.bvar 0)
  unless body.consumeMData == mkApp (mkConst (dottedName "YMGBridge.SourceResult")) matrix do
    throw "translation target does not retain the source result for the same matrix group"

def main (args : List String) : IO UInt32 := do
  let [moduleText, theoremText] := args
    | IO.eprintln "Usage: InspectYMGTranslation.lean Module Theorem"; return 1
  let env ← importModules #[{ module := dottedName moduleText }] {} 0
  match checkShape env with
  | .error error => IO.eprintln s!"SOURCE_TRANSLATION_REJECTED: {error}"; return 1
  | .ok () => pure ()
  let name := dottedName theoremText
  let some (.thmInfo info) := env.checked.get.find? name
    | IO.eprintln "SOURCE_TRANSLATION_REJECTED: submitted declaration is not a theorem"; return 1
  let [u] := info.levelParams
    | IO.eprintln "SOURCE_TRANSLATION_REJECTED: proof must have one universe parameter"; return 1
  unless info.type == mkConst target [.param u] do
    IO.eprintln "SOURCE_TRANSLATION_REJECTED: wrong, fixed-universe or conditional target type"
    return 1
  let axioms ← (Lean.collectAxioms name : CoreM (Array Name)).toIO'
    { fileName := "<ym-ymg-translation-inspector>", fileMap := default } { env := env }
  let extra := axioms.filter (fun ax => !allowed ax)
  unless extra.isEmpty do
    IO.eprintln s!"SOURCE_TRANSLATION_REJECTED: unapproved transitive axioms {extra.toList}"
    return 1
  IO.println (s!"SOURCE_TRANSLATION_CHECKED: {theoremText} : " ++
    "YMGBridge.PresentedJointExistence.{u}")
  IO.println s!"Transitive axioms: {axioms.toList}"
  IO.println "Scope: equivalent source statement on presented matrix groups; NOT YangMillsExistenceOnly or a mass-gap certificate."
  return 0
