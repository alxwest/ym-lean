# Yang–Mills existence and mass gap in Lean

This project expresses the logical structure of Jaffe and Witten's problem,
with comments following their exposition. It is a **statement interface**, not
a complete formalization of quantum field theory and not a proof of the problem.

Start with [YangMills/Statement.lean](YangMills/Statement.lean). Its final definition,
`YangMillsExistenceAndMassGap`, says that every compact simple gauge group admits
a non-trivial continuum quantum Yang–Mills theory on four-dimensional spacetime
with a positive, finite mass.

| Jaffe–Witten | Lean location |
| --- | --- |
| §1: gauge group and pure Yang–Mills dynamics | `Framework.GaugeGroup`, `compactSimple`, `pureYangMillsDynamics` |
| §3: axiomatic quantum field theory | `Framework.axiomaticQFT` |
| §4: local observables and ultraviolet behavior | `localGaugeObservables`, `ultravioletBehavior` |
| §4: existence and non-triviality | `IsQuantumYangMills` |
| §4: spectral gap and finite mass | `IsMassGap`, `HasPositiveFiniteMass` in `YangMills/Spectrum.lean` |
| §4: quantified problem | `YangMillsExistenceAndMassGap` |

The [reference PDF](source/yangmills.pdf) is supplied in this repository; the
[official online version](https://www.claymath.org/wp-content/uploads/2022/06/yangmills.pdf)
provides the source, especially §§3–5.

## What is formalized

The spectral clause uses actual real numbers and sets: some Δ > 0 has no
spectral energy strictly between 0 and Δ, and the set of all such Δ is bounded
above. Together these conditions make its real supremum a positive finite mass.
The gap need not be attained by an eigenvalue. The file proves the equivalent
energy-threshold formulation under positive energy, and proves that a positive
spectral value bounds all gaps.

## What remains an interface

`Framework` takes the geometric and analytic prerequisites as explicit
parameters: Lie groups, candidate QFTs, full QFT axioms, renormalized local
observables, Yang–Mills dynamics, short-distance asymptotics, non-triviality,
and the relationship between the Hamiltonian and its spectrum. These are
documented obligations, **not implemented definitions**. Consequently, even a
proof of the parameterized statement for an arbitrary framework would not by
itself solve or fully formalize the Clay problem. In particular, an empty class
of gauge groups or predicates set to `True` would make a meaningless instance.

The next foundational work is to instantiate these interfaces with concrete
mathematical structures and justify their correspondence with the source.
No conjecture is installed as an axiom and there are no `sorry` proofs.

## Build

With Lean's `elan` installed:

```sh
lake update
lake exe cache get
lake build
```

Lean and mathlib are pinned by `lean-toolchain`, `lakefile.toml`, and the Lake
manifest. `lake build` checks the statement and the spectral lemmas; it does
not establish existence of a Yang–Mills theory.
