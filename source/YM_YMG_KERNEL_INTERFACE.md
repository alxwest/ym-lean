# Exact full-Schwartz kernel bridge: remaining source obligations

This note describes the checked target-side source/target kernel bridge
in [`YMYMGKernelInterface.lean`](../YangMills/YMYMGKernelInterface.lean).
It is **existence-only**, not a mass-gap proof or a claim of unconditional
cross-repository equivalence.

## Mathematical transport already available

The prior [spacetime/Schwartz module](../YangMills/YMYMGSpacetimeBridge.lean)
supplies reversible continuous linear maps between the October source's
full `SchwartzMap (Points n) ℂ` and the target's
`SchwartzMap (Fin n → Spacetime) ℂ` for every arity.

The new `YmymgFullKernelInput Q` structure states the exact remaining
conditions for the **same physical Wightman theory `Q`**:

1. One product-test map with the literal product formula.
2. Density of the linear span of the product tests in the full n-point
   Schwartz space.
3. The **actual source selected-phase** continuous n-point functionals
   expressed on its original `YM.Boundary.Joint n` type.
4. Equality of those transported source functionals, on every physical
   product test, with `Q.vacuumNPoint` of the same field indices.

None of these is replaced by a limit merely on separated configurations.

## Checked new theorems

- `YmymgFullKernelInput.toWightmanVacuumKernels` produces the **exact**
  target `WightmanVacuumKernels Q` without changing Hilbert space,
  vacuum, or physical field operators.
- `kernel_transport` is an equality of continuous functionals evaluated
  on arbitrary full-Schwartz tests, not a relation limited to products.
- `source_kernel_unique` proves that two source functionals satisfying
  this physical interface must coincide **on the full Schwartz space**,
  including any contact-sensitive tests. This uses the target's existing
  kernel uniqueness theorem and the invertible source/target transport.

All three compile and their axiom reports contain only standard Lean
foundations (see [audit](../YangMills/YMYMGKernelInterfaceAudit.lean)).

## What is still genuinely missing

In [YM-ymg's `Boundary/Contour.lean`](https://github.com/alxwest/YM-ymg/blob/main/submissions/openai-20261028/submission/YM/Boundary/Contour.lean),
`Surface.W` already has values in the source full-Schwartz
distribution type. In
[`PublicView.publicMoment`](https://github.com/alxwest/YM-ymg/blob/main/submissions/openai-20261028/submission/PublicView.lean),
the source identifies the selected Wightman word value with its
boundary distribution on a product test.

But a checked instantiation of **all fields** in
`YmymgFullKernelInput` still requires the precise cross-repository
field-index adapter, source-selected phase matching, and the
**Schwartz tensor-density** theorem. The construction's selected
correlator must be transported, not replaced by an arbitrary functional.

This leaves the target [issue #4](https://github.com/alxwest/ym-lean/issues/4)
open. The generated/UV matching and self-adjoint physical Hamiltonian
are separate tasks; this bridge does not address them.

## Reproduction

```sh
lake build YangMills.YMYMGKernelInterface YangMills.YMYMGKernelInterfaceAudit
```
