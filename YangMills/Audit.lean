import Lean
import YangMills.Statement

/-!
# Audit submitted proofs

Ordinary Lean allows `sorry`, or a theorem proved using a newly declared axiom.
These commands reject both, transitively. The only permitted foundational axioms
are Lean's usual `propext`, `Classical.choice`, and `Quot.sound`.

`#audit_axioms declaration` audits dependencies; it does not check a target.
`#check_qft_proof declaration` additionally requires exactly the closed
`QFTExistenceAndMassGap` proposition. A conditional theorem cannot pass it.
Neither command certifies the as-yet-unspecified Yang–Mills identification.
-/

open Lean Elab Command Meta

private def auditDeclaration (name : Name) : CommandElabM Unit := do
  let axioms ← Lean.collectAxioms name
  let unexpected := axioms.filter fun n =>
    n != ``propext && n != ``Classical.choice && n != ``Quot.sound
  unless unexpected.isEmpty do
    throwError "Proof audit rejected {name}: unapproved axioms {unexpected.toList}"
  logInfo m!"Axiom audit passed for {name}."

elab "#audit_axioms " id:ident : command => do
  let names ← liftCoreM <| realizeGlobalConstWithInfos id
  for name in names do
    auditDeclaration name

elab "#check_qft_proof " id:ident : command => do
  let names ← liftCoreM <| realizeGlobalConstWithInfos id
  unless names.length == 1 do
    throwError "Expected one unambiguous declaration."
  let name := names[0]!
  liftTermElabM do
    let info ← getConstInfo name
    unless ← isDefEq info.type (mkConst ``YangMills.QFTExistenceAndMassGap) do
      throwError "Wrong target: expected exactly YangMills.QFTExistenceAndMassGap, without extra hypotheses."
  auditDeclaration name
  logInfo "QFT-and-gap target checked. This is not a certification of Yang–Mills."
