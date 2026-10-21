# Full kernels, actual BV identities and the quantum observable quotient

These are fixed definitions and supporting proofs, not a Yang--Mills existence
proof. The full target remains unadmitted pending the specific remaining
fidelity obligations.

## Full Wightman kernels of the same theory

`GeneratedCandidate.vacuumKernels` supplies continuous full-Schwartz kernels
for ALL actual Q component words. Their tensor values are the existing same-H
operator vacuum expectations. Pointwise tensor-product equations and density
make the kernels unique, as proved in `WightmanVacuumKernels`. An unrelated
correlator cannot satisfy that dense-span identification. The existing C-word
kernels separately identify with finite combinations of those same operators.

`WightmanNPointContinuity` proves actual complex multilinearity and separate
continuity at every slot, using reverse adjoints on the same invariant domain.
`WightmanVacuumPositivity` identifies adjoint-concatenated word correlations
with actual Hilbert inner products and proves their finite Borchers positivity.
No boundedness or essential self-adjointness of smeared fields is required.

## Primary author/source audit

Streater's [author exposition](https://www.scholarpedia.org/article/Wightman_quantum_field_theory),
sections “The Wightman Axioms for a Scalar Field” and “The Wightman
Distributions”, identifies the common-domain, weak-continuity and tempered
full-kernel formulations, including the nuclear-kernel step. Its scalar
exposition is not a proof of the full multiplet/framework equivalence here.
The cited book's [publisher record](https://www.jstor.org/stable/j.ctt1cx3vcq)
locates chapter 3 at pp.96–133; full chapter access was unavailable in this
session. No complete direct audit of that chapter is claimed.

| Source quantity | Concrete proposed condition | Supporting boundary |
|---|---|---|
| Positive separable Hilbert space | WightmanAxioms.complete/separable and actual inner product | Small-model/universe transport |
| Covariant common-domain fields | WightmanData.field/domainAction and actual adjoint/covariance equations | Countable bosonic multiplet presentation |
| Tempered distributions | Full actual-word continuous Schwartz kernels | Standard tensor realization/density and economical-axiom redundancy |
| Spectrum in the forward cone | Actual integrated unitary translation test equation | Joint spectral-measure support equivalence |
| Locality and cyclic vacuum | Same-domain spacelike commutation and actual word span density | Test/kernel and analytic tube equivalences |

The direct kernel presentation fixes the multipoint meaning. Deriving it as
a redundant consequence of the economical original single-field axioms still
requires additional library analysis, summarized below.

# Actual n-point continuity support

`YangMills/WightmanNPointContinuity.lean` proves the reverse-order adjoint identity on the existing common invariant domain, linear and continuous dependence of the actual vacuum expectation on an arbitrary interior slot, and an actual complex multilinear map at every arity. Its values are proved equal to the existing vacuumNPoint; no candidate may supply different n-point values. The final theorem gives separate continuity explicitly for every Fin-indexed test-function slot.

The file strict-compiles with autoImplicit=false and warningAsError=true in the pinned project. Audited central theorems use only propext, Classical.choice and Quot.sound. The spectral module is frozen and was not edited during this work.

The precise remaining supporting bridge is:

1. Establish that the actual Schwartz seminorm topology is Frechet/complete (and hence Baire/barrelled). The pinned SchwartzSpace implementation supplies WithSeminorms and FirstCountableTopology, but `#synth CompleteSpace YangMills.TestFunction` fails. No completeness theorem was found in its source. This is a missing library proof, not evidence that Schwartz space is mathematically incomplete.
2. Prove the standard promotion from separately continuous finite multilinear scalar maps on these Frechet spaces to joint continuity. Pinned mathlib has the barrelled Banach-Steinhaus theorem, but no ready general separately-continuous multilinear promotion was located. No additional physical assumption is justified by this library gap.
3. Prove the Schwartz nuclear kernel correspondence: the jointly continuous multilinear functional on n copies of S(R^4) extends uniquely to a continuous linear functional on S(R^(4n)), with tensor-test values fixed by the actual vacuum words. Neither a Schwartz nuclearity/completed-projective-tensor isomorphism nor this kernel theorem was found in the pinned distribution modules. Density/uniqueness and the continuity estimate are part of the theorem, not freely chosen multipoint data.

These steps would complete the specific multipoint tempered-distribution adequacy argument. They do not involve constructing a Yang--Mills model or proving the mass gap.

## Direct cited-standard presentation

The additional frozen module `YangMills/WightmanVacuumKernels.lean` supplies a direct alternative to waiting for the preceding library derivation. It requires actual full-Schwartz continuous kernels for all Q component words, fixed pointwise product tensor tests, tensor-span density, and exact equality to Q's existing vacuum expectations on every tensor. The module proves uniqueness of tensor tests and full kernels, an extensional uniqueness theorem against any proposed continuous kernel, and coverage of every existing finite field word. It strict-compiles without new axioms.

Adding this concrete witness to the proposed candidate makes multipoint temperedness an explicit standard condition. It does not let the candidate choose correlation values, and it introduces no Gaussianity/particle/scheme assumption. Its fidelity justification is that standard Wightman n-point distributions already have precisely these continuous Schwartz kernels and tensor values. Standard tensor existence/density and the kernel correspondence remain supporting source-equivalence mathematics. They no longer leave the *meaning* of candidate multipoint temperedness unstated. This direct presentation does not by itself prove its redundancy from the economical original single-field continuity axioms.

## Actual interacting BV scope

The four nonlinear basic transformations are derived from the fixed actual
master-action vertices. The shifted-antighost and nonlinear ghost nilpotency
identities now follow from that same action, the actual pointwise product
rule, odd-jet anticommutation and actual Lie color Jacobi. The auxiliary
antifield image B-i barc-dagger is also extracted from those vertices.
Interacting A/B nilpotency, other antifield equations, promotion to arbitrary
superjet polynomials and the full CME/divergence descent are still in progress.

## Actual quantum cohomology

`FilteredQuantumCohomology` uses full formal hbar power series of the SAME
physical generated Q coefficients. Its differential raises degree and ghost
number by one and flips parity; the two rectangular maps retain all allowed
intermediate monomials. Their composition is proved zero from the actual
Filtered/Nilpotent coefficient equations. Thus the exact image lies in the
cocycle kernel, giving a real quotient module H0. Existing corrected lifts
are proved closed and define actual quotient classes. No injectivity,
surjectivity or classical/quantum isomorphism is asserted. Identifying formal
classes with physical operators still uses the separate same-C UV/Wick/word
bridges; no nonperturbative ghost Hilbert quotient is inferred.

## Remaining general Legendre chain rule

Actual flow jets preserve graded statistics and mean-field roots use the
background law only on balanced momenta. Sorted block permutations and their
actual selected indices/momenta are computed. The weighted Koszul sign is
proved equal to the ordinary sign on the odd-position subsequence. The
universal external-permutation factorization and its full finite-sum reindexing
are still being completed before removing any computed-inversion guard.
