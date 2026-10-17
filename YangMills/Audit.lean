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

/-!
# Full Clay certification gate (fail closed)

The repository deliberately has no declaration encoding the entire Jaffe--Witten
problem. In particular, `QFTExistenceAndMassGap` does not connect its fields to
Yang--Mills observables for a specified gauge group. A checker that accepted a
proof of it as a Clay certificate would be unsound as a certification *claim*.

`#check_clay_proof` must reject every submission until a separately reviewed,
fixed, full-strength mathematical statement is actually formalized. Do not
replace this gate with a check for an arbitrary user-supplied `Prop` or a
placeholder equivalent to `True`.
-/

/-- Report readiness without incorrectly calling a successful library build a proof. -/
elab "#clay_certification_status" : command => do
  logInfo "CLAY_CERTIFICATION_BLOCKED: Classical curvature-jet polynomials and QFT n-point functions are defined, but renormalized gauge-invariant quantum correspondence, UV/OPE requirements, nontrivial Yang--Mills identification, and groupwise existence remain missing. See CERTIFICATION.md."

/-- Intentionally rejects *every* submitted theorem. There is currently no
mathematically complete closed Clay target to compare against, so accepting
any declaration would amount to certifying an unreviewed weaker statement.
After the missing mathematics is developed and the fixed target independently
reviewed, replace this with an exact-type check plus `auditDeclaration`. -/
elab "#check_clay_proof " candidate:ident : command => do
  let names ← liftCoreM <| realizeGlobalConstWithInfos candidate
  unless names.length == 1 do
    throwError "Expected one unambiguous declaration."
  throwError "CLAY_CERTIFICATION_BLOCKED: no full, reviewed, closed Yang--Mills Millennium statement is encoded in this library. QFTExistenceAndMassGap is insufficient. See CERTIFICATION.md."
