# Wilson comparison and spectral transfer from alxwest/ym

```sh
lake build YMResearch
```

The integration uses the native operator and spectrum definitions. It accepts
arbitrary cutoff filters and conditional probability kernels, so YM4 can use
its own odd-`L` Wilson sequence.

## Physical mass gap ([#37][issue-gap])

- [FixedTimeTransfer.lean](YMResearch/FixedTimeTransfer.lean) passes a common
  fixed-time bound to the full excitation space. The projected norm squares
  converge and the continuum form can be recovered from below. For unprojected
  data, the inputs are the Gram form, the fixed-time form and the norm square
  of the projection onto the entire zero-energy space. One vacuum overlap
  suffices when that space is one-dimensional. The recovered words must
  include linear combinations with dense range. [Source recovery and corrected
  projections][source-fixed]
- [HamiltonianGap.lean](YMResearch/HamiltonianGap.lean) connects the bound to the
  unbounded native Hamiltonian. `isMassGap_of_plateauLimits` takes the three
  convergences and a projected contraction ratio `0 < R < 1` at physical time
  `τ > 0`. It proves a native gap of size `-log R / τ` by constructing a
  bounded two-sided resolvent at each real energy in that interval. The
  continuum heat evolution must differentiate to the same operator on its
  domain. The cutoff inputs can come directly from powers of discrete transfer
  operators.
- [CommonDecay.lean](YMResearch/CommonDecay.lean) implements the alternative
  common-rate argument. The spectral measures and bounded band projections
  must agree on each band's mass and detect the positive spectrum of the
  actual Hamiltonian. The prefactor and starting time can vary with the word.
  The exponent must be common. The source's diagonal example with energies
  `1/n` shows why rates that depend on the word cannot be used. A supported
  excitation measure with positive mass on `(0, ∞)` supplies the additional
  positive spectral point needed for `HasPositiveFiniteMass`.
  [Source criterion and counterexample][source-decay]

For a selected YM4 scalar component, the conditional phase construction
provides pure cutoff states approximating its separated moments and identifies
the zero-energy plateau with the invariant conditional expectation. On the
span of separated positive-time scalar words, the Gram and time forms are
reflected moments at times `0` and `a_j k_j → τ`. The rank-one plateau is the
squared vacuum overlap. This identifies the convergence inputs to check on
that sequence. The outstanding estimate is one strict normalized contraction
on the actual cutoff words, or one common exponential rate on the continuum
words. The native application also needs the same-generator identification
and density in the final joint physical space. The same spectral lemmas
apply to the continuum Hamiltonian in [#7][issue-ymg-gap] when its own
recovery and contraction or decay estimates are available.
[YM4 phase extraction][ym4-phase] · [Cutoff plateau][ym4-plateau] ·
[Hamiltonian and joint observables][issue-reconstruction] · [F4][issue-joint]

## Exterior averaging for F2 ([#31][issue-f2])

[WilsonComparison.lean](YMResearch/WilsonComparison.lean) takes the actual and
reference conditional laws of the **joint** plaquette-curvature readout and
averages them under the original Wilson exterior distribution. A test bounded
by `M` has expectation error at most `M` times the averaged full variation mass
(twice the probability total variation distance). On a good exterior set `G`,
an integrable variation envelope `ε` gives the bound
`M * (∫_G ε dμ + 2 μ(Gᶜ))`. Use the joint law for the mixed fourth moment and
the one-plaquette tests for the marginal means. For an unbounded Gaussian
observable, the truncated test bound needs the corresponding tail errors.
[YM4 pair comparison and scale sum][ym4-fp]

The source uses exterior averaging for a marked boundary score. Its one-shell
through-`g²` calculation concerns that score and has independent review
pending. For F2, the next input is a cutoff-uniform variation envelope for the
pair on YM4's centered block, with a weighted error summable over its scales.
D1 and the interacting F2–F3 estimates on a common admissible first-passage
sequence remain open. [Source exterior averaging][source-wilson] ·
[One-shell scope][source-score] · [Review status][source-ledger]

[issue-gap]: https://github.com/alxwest/ym-lean/issues/37
[issue-f2]: https://github.com/alxwest/ym-lean/issues/31
[issue-reconstruction]: https://github.com/alxwest/ym-lean/issues/33
[issue-joint]: https://github.com/alxwest/ym-lean/issues/34
[issue-ymg-gap]: https://github.com/alxwest/ym-lean/issues/7
[source-fixed]: https://github.com/alxwest/ym/blob/cfc91beb5f0cead7c16d673c4696dda2b6c4b298/programme/ym_mass_gap_route/STREAM8_CONTINUUM_GAP_TRANSFER.md#L848-L998
[source-decay]: https://github.com/alxwest/ym/blob/ea9e04bed56ffa896a29e9200f875004a8f24076/programme/ym_mass_gap_route/STREAM8_CONTINUUM_GAP_TRANSFER.md#L673-L767
[source-wilson]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/ym_wilson_hard_boundary_score_20261109/SCORE.md#L21-L36
[source-score]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/experiments/stream0/ym_wilson_hard_boundary_score_20261109/BULK_SCORE.md#L42-L52
[source-ledger]: https://github.com/alxwest/ym/blob/a23b9a07863c7ad03516927390a60b5ef4ab9b3a/ledger/stream0_ym_wilson_hard_boundary_score_20261109.yaml
[ym4-phase]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=1223
[ym4-plateau]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/YM4_1400.pdf?raw=true#page=1300
[ym4-fp]: https://github.com/alxwest/Yang--Mills-LLM-experiment/blob/c7fef8b21b5846e1b5806a7d4f915737b9130c27/YM4/FP/YM4_FP.tex#L1274-L1403
