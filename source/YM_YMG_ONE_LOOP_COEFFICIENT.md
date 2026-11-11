# YM-ymg versus ym-lean: first perturbative coefficient check

**Checked 11 November 2026. This is a numerical-convention comparison,
not an existence or all-orders perturbative-matching proof.** It does
not assume a Yang–Mills mass gap.

## Exact formula sources

The October [YM-ymg fork](https://github.com/alxwest/YM-ymg/tree/55ba9fc36293b3f4d52c6b1f813169a0be76ee98)
uses these definitions:

- `YM/Gauge/Colors.lean`: `slopeConstant G = 11 G.casimir / (24 pi²)`
- `YM/Pert/Asymptotics/RawAxis.lean`: `b0 G = 11 G.casimir / (48 pi²)`
- `YM/TraceExtension/Chart/Nectar.lean`: `d2 G = -b0 G / 2`
- `YM/TraceExtension/Verse/Day.lean`: `award G = 12 (d2² / b0²) dim(g)/pi⁴`

The target [`YangMills/Renormalization.lean`](../YangMills/Renormalization.lean)
defines `Perturbative.adjointCasimir e` from the actual chosen invariant
form/color frame, and the **explicit** two-loop polynomial:

```text
betaTwoLoop(g) = -(11/3) C_A/(4 pi)^2 g^3
                 -(34/3) C_A^2/(4 pi)^4 g^5
```

## What has actually been proved in Lean

[`YMYMGLeadingCoefficient.lean`](../YangMills/YMYMGLeadingCoefficient.lean)
kernel-checks the following statements:

1. The group's Wilson slope is twice its own first-loop coefficient.
2. **If `G.casimir = Perturbative.adjointCasimir e`**, the numerical coefficient
   of `g³` in the explicit target beta polynomial is exactly the group's
   `-b0`. This is an equality of polynomial conventions.
3. With `b0 != 0`, the group's algebraic trace coefficient `award`
   simplifies to `3 dim(g) / pi⁴`.

The [axiom audit](../YangMills/YMYMGLeadingCoefficientAudit.lean) reports
only `propext`, `Classical.choice`, and `Quot.sound` for these results.

## What remains unproved

- **Casimir identification**: different gauge-group and invariant-form
  representations require a genuine equality theorem, not an assumption
  that similar notation guarantees equal normalization.
- **Physical beta**: the explicit target `betaTwoLoop` is not the
  generated `GeneratedScaleNormalization.betaSeries` by definition.
  The latter is computed from an independent scale-insertion/flow
  system. The corresponding equality at the first nonzero order has
  **not** been proved here.
- **Physical trace**: the source's actual selected centered stress trace
  and its `award` limit have not been matched to the target's same-field
  centered-trace-anomaly and curvature-square two-point distribution.
  Algebraically identical prefactors do not establish that identity.
- **All orders**: no equality of the remaining generated OPE coefficients
  or renormalized physical observables follows.

Therefore the **first numerical coefficient does not exhibit a mismatch**.
The main obstacle remains the physical/generated identification, tracked
in [issue #2](https://github.com/alxwest/ym-lean/issues/2) and
[issue #6](https://github.com/alxwest/ym-lean/issues/6).

## Reproduction

From the target `alxwest/ym-lean` checkout using pinned Lean 4.31.0:

```sh
lake build YangMills.YMYMGLeadingCoefficient
lake build YangMills.YMYMGLeadingCoefficientAudit
```
