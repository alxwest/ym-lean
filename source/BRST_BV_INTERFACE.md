# BRST/BV interface for fixed renormalized predictions

This specifies algebra and equations to implement. It does not label a partial implementation complete. Primary source is Fröb–Holland–Hollands, arXiv:1511.09425 (82-page PDF), supplemented by Fröb–Holland arXiv:1603.08012 (70 pages). Source PDFs and extracted text are in this directory.

## Checked classical core

`BRST.lean` imports the existing actual-G renormalization definitions. It defines exterior-valued ghosts, proves their squares vanish and their generators anticommute, defines the actual-bracket quadratic ghost variation, and proves the degree-one Chevalley–Eilenberg differential squares to zero using G's Jacobi identity. It also defines the antifield-free superjet algebra as commuting gauge/auxiliary jet polynomials tensored with exterior ghost/antighost jets. Canonical even partial derivatives and odd exterior contractions define an explicit coordinate differential, total jet derivatives, and the full antifield-free classicalBRST map on every polynomial. Finite partial support is proved by Clifford and tensor induction; the coordinate sums therefore cannot vanish through infinite-support totalization. Linearity and exact generator evaluation are proved. Ordered external differentiation and augmentation fix the polynomial-to-amplitude coefficient map, including factorials/signs.

This is a genuine Grassmann algebra, not an assignment of real values to ghost fields. The full graded Leibniz and nilpotency equivalence proofs for the concrete classicalBRST map, antifields and the local-functional BV quotient remain unfinished. The CE nilpotency result is the ghost sector, not a claim of full BRST nilpotency. Exterior contraction's graded product identity is proved by induction; it supplies the core odd-partial Leibniz step.

The checked images are the real-bracket **unshifted** convention `sA=Dc`, `sc=−g[c,c]/2`, `s cbar=B`, `sB=0`. The positive diagonal covariance currently used by the flow file employs the shifted B convention of primary equations(45)–(49). Before composing these modules, transport the action and s through that field substitution, including its i factors, or derive an equivalent real convention. Combining unshifted transformations with shifted propagators is not valid.

## Canonical jet labels and grades

Let BasicField be the actual-G fields already defined. Extended generators are basic or antifield labels, plus ordinary derivative multiindex α:Fin4→N. The basic grades are

| field | engineering dimension | ghost number | Grassmann parity |
|---|---:|---:|---:|
| A | 1 | 0 | 0 |
| c | 1 | 1 | 1 |
| cbar | 1 | −1 | 1 |
| B | 2 | 0 | 0 |

For the antifield of φ set dimension `3−dim φ`, ghost number `−1−gh φ`, parity `1−parity φ`. Add |α| to dimension, leave other grades unchanged. This is exactly primary TableI and eq(54), p14. The engineering assignment is a convention chosen for these analytic estimates; it differs from some physics ghost assignments, so document it.

On homogeneous jet words all grades add. Odd generators exterior commute, even generators commute. A finite word with repeated identical odd jet is zero; different odd derivative jets are independent generators. The algebra is not merely a list of noncommuting words: relations must be imposed/proved and coefficient extraction must respect them.

## Graded derivative signs

For an ordered word `w=x1...xn`, the left partial derivative by a generator z is the sum over matching occurrences i of the word with xi removed, multiplied by

`(-1)^(p(z) Σ_(j<i) p(xj))`.

The right derivative instead uses `Σ_(j>i) p(xj)`. For a homogeneous polynomial F,

`D_R,z F = (-1)^(p(z)(p(F)+1)) D_L,z F`.

This convention is fixed by `δF=(δ_R F/δφ)δφ=δφ(δ_L F/δφ)`, primary eq(57), p15. It determines all loop and partition signs. For the ordered covariance convention `C_cbar,c=−C`, `C_c,cbar=+C`, the Gaussian contraction operator `Δ_C=(1/2)Σ_MN C_MN D_L,N D_L,M` satisfies `Δ_C(φ_Aφ_B)=C_AB`; the odd reverse-order term has both the derivative and covariance signs. This is a useful exact regression lemma.

For jets, variational derivatives on local functionals are Euler derivatives: sum over α of `(-∂)^α D_(φ,α)`. Total derivatives ∂µ must first be defined as even derivations sending each jet α to α+eµ. The quotient by total divergences implements integration by parts. One cannot apply an ordinary finite polynomial derivative to a local functional and call it the BV variational derivative.

## Fixed classical BV bracket and master action

Primary eq(56), p15, is

`(F,G)=∫Σ_K[(δ_R F/δφK)(δ_L G/δφ‡K)−(δ_R F/δφ‡K)(δ_L G/δφK)]`.

The bracket is odd, ghost number+1. In local-functional dimension conventions it lowers the sum of engineering dimensions by3. Its antisymmetry is

`(F,G)=−(-1)^((pF+1)(pG+1))(G,F)`.

The classical action including the specified actual-G antifield couplings is fixed by eq(49). Define `s_hat F=(S,F)`. Prove `(S,S)=0` from the actual Lie bracket, invariance of B, graded integration by parts and auxiliary gauge fixing; then graded Jacobi proves `s_hat²=0`. These are eqs(50)–(60), pp14–15. Neither S nor s_hat is a proof-author-selected meaning.

On the pointwise classical jet algebra before the local-functional quotient, the basic BRST images extend by the odd Leibniz rule and must commute with total derivatives. Descending to the divergence quotient and proving master-action identities are separate supporting lemmas.

## Allowed counterterms: finite-dimensional local freedom, restored Ward identities

Primary eq(70), p16, fixes `L_bare=S_int+O(ℏ)`. At finite cutoff its higher-loop counterterms may be BRST breaking, because the cutoff itself breaks BRST. The source explicitly says to allow the most general local polynomial of dimension≤4 preserving unbroken E(4) and ghost number. Forcing each finite-cutoff counterterm to be classically BRST closed can exclude the required restoration terms.

One-insertion counterterms are linear maps δ:local operators→local operators with δ=O(ℏ), preserved ghost number/parity/global tensor type and output dimension≤input dimension. This is eqs(77)–(79), p18. Higher insertion counterterms are local on partial coincidence diagonals, with derivative order bounded by dimension. Their coefficients are finite-dimensional at every bounded label degree and perturbation order. Translation invariance makes coefficients independent of spacetime position; arbitrary smooth momentum functions are not local counterterms.

The prescribed flow generates amplitudes from that local data; continuum Ward identities constrain it. Remaining homogeneous local counterterm solutions must be classified modulo s_hat-exact terms and divergences, with the physical coupling/field normalization fixing the gauge-invariant F² direction. For a compact simple algebra the quadratic invariant is one-dimensional after choosing B. In the parity-even pure-YM sector the CP-odd F∧F direction is excluded in the auxiliary perturbative scheme; this need not add parity invariance of a future nonperturbative vacuum as a new axiom. A proof of this cohomology/stability classification is still required; naming it is not a substitute.

Thus the appropriate interface quantifies finite local counterterm coefficients satisfying explicit power-counting, global covariance, tree normalization, flow equations and all restored Ward equations. This is legitimate witness freedom. An arbitrary continuum coefficient distribution tagged “renormalized” remains illegitimate.

## Quantum BRST and contact data are coefficient families constrained by amplitudes

Use formal coefficient families Q_A^B and B_AB^{C,α} in g and ℏ. Fixed classical terms are the above s_hat and BV bracket; corrections begin at ℏ. Their support/grading equations are

* Q_A^B=0 unless `[B]≤[A]+1`, `ghB=ghA+1`, `pB=pA+1`.
* B_AB^{C,α}=0 unless `[C]+|α|=[A]+[B]−3`, `ghC=ghA+ghB+1`, `pC=pA+pB+1`.

The second gives the distribution

`(O_A(x),O_B(y))_ℏ=Σ_C,α B_AB^{C,α} O_C(x) ∂_x^α δ⁴(x−y)`.

This is 1603.08012 eqs(1.1.5)–(1.1.6), p5. It is a concrete partial-diagonal distribution; a freely chosen predicate “local contact term” is insufficient. The dimension bounds make its sum finite.

Impose q_hat²=0, odd bracket antisymmetry, odd Jacobi, and

`q_hat(F,G)_ℏ=(q_hat F,G)_ℏ+(-1)^(pF+1)(F,q_hat G)_ℏ`.

These are primary1511.09425 eqs(11)–(13), pp6–7. **Do not require a naive quantum Leibniz rule with the raw classical pointwise product.** Composite renormalization changes products and creates contact terms; the cited theorem does not justify adding that extra axiom. Classical s is a derivation, while quantum q_hat is fixed on composite labels through the amplitude Ward identities.

For connected amputated functionals L, the full restored conditions are primary Proposition17 eqs(281)–(283), pp54–55:

`s_hat0 L=0`, `s_hat0 L(O_A)=L(q_hat O_A)`,

`s_hat0 L(⊗A)=Σ_k L(⊗_(j≠k) A_j ⊗q_hat A_k)+Σ_(k<l)L(remaining⊗(A_k,A_l)_ℏ)`.

These are formal coefficientwise distribution identities in external fields/antifields, not merely vacuum scalar equations. The signs for odd inserted composites are determined by adjoining a distinct auxiliary odd ε_k to each odd insertion, applying the bosonic formula to ε_k O_Ak and extracting the ordered ε product. This is the source's explicit prescription immediately after eq(283). It avoids guessing contact permutation signs. For disconnected functionals G the corresponding identity has **−ℏ** in front of the contact term, 1603.08012 eq(3.3.4), p20; do not copy the connected sign into it.

Gauge-invariant OPE closure then imposes eq(1.1.4), p5, on the **same extracted** coefficient system. Input q_hat terms minus output q_hat terms minus ℏ contact terms vanish, with the same Koszul prescription. Asymptotic OPE alone does not imply that exact Ward equation; the paper explicitly warns about this on p6 and p20.

## Anomaly removal and non-free physical correspondence

The gauge anomaly is a local form at ghost number1 and form degree4. The relevant equivariant cohomology vanishes in parity-invariant pure YM; groups with cubic invariants are not excluded. Finite corrections remove the action anomaly A0. For physical insertions the residual A1 obeys a consistency equation; primary eqs(360)–(364), p71, writes its leading term as `A1(O)=s_hat B1(O)` with B1 of the same engineering degree and ghost number as O, and changes the insertion counterterm by −B1. This precisely explains allowable operator mixing and why arbitrary quantum q_hat corrections cannot simply be chosen independently.

A completed implementation must construct the deformed maps from the fixed amplitude/counterterm system or impose all these coefficient equations on that system. Then prove that ghost-number-zero physical cohomology, mapped to Q's observable family with fixed mixing relations, gives the intended invariant curvature polynomials. Mere q_hat nilpotency with an unused classical action would leave the disconnected-sector loophole.

## Concrete unfinished steps

1. Extend the checked classical generator images to the superjet graded derivation and transport the B shift consistently with the flow covariance.
2. Add antifields, total derivatives/Euler operators and the quotient of local functionals by divergences; prove the actual master equation and BV identities.
3. Enumerate local counterterm and insertion spaces with exact dimension/ghost/parity/covariance constraints; normalize the physical coupling direction and transport finite mixing.
4. Attach full coefficientwise restored Ward equations to the same flow amplitudes and local contact distributions; prove equivalence of the auxiliary-ε and explicit Koszul implementations.
5. Establish physical cohomology/correspondence and its finite-renormalization covariance before claiming fixed all-order YM predictions.

These are central mathematical tasks. The checked ghost core is useful progress toward them, not evidence that they are finished.

## Coherent shifted-B component action and its fixed free differential

For the current component flow convention with positive ghost density `∂cbar·Dc`, Feynman gauge and positive auxiliary B², a coherent complex auxiliary convention is

`sA=Dc`, `sc=−g[c,c]/2`, `s cbar=div A+iB`, `sB=i div Dc`.

It makes `s² cbar=div Dc+i² div Dc=0`; invariance of the gauge-fixing/ghost sector follows by integration by parts: `sS_gf=(div A+iB)div Dc` and `sS_ghost=−(s cbar)div Dc`. This is a component convention equivalent to the source's form/antighost phase convention only after a consistent field substitution; that equivalence must be proved rather than asserting identical printed signs.

With `S_BV=S−Σ(sφ)φ‡`, the free action contains the quadratic physical/gauge-fixing terms and the source bilinears

`−∂µc A‡µ −(div A+iB)cbar‡ −i∆c B‡`.

The interaction action excludes these bilinears and adds the g-dependent vertices

`−g[Aµ,c] A‡µ + g[c,c]c‡/2 −ig div[A,c] B‡`.

The last term can be written `+ig[Aµ,c]∂µB‡` modulo a total derivative. All brackets are actual-G contractions. There is no independent cbar‡ interaction at this order.

The **derived** free ST images in this convention are

`s0 Aµ=∂µc`, `s0 c=0`, `s0 cbar=div A+iB`, `s0B=i∆c`,

`s0 A‡µ=−∆Aµ+∂µ cbar‡`, `s0B‡=B−i cbar‡`,

`s0 cbar‡=∆c`, `s0 c‡=−∆cbar−div A‡+i∆B‡`.

They follow from the fixed right/left Euler derivative convention and S0, not a free functional operator. Composing s0 on each generator cancels exactly, using commuting total derivatives; e.g. on c‡ the ∆div A, ∆B and ∆cbar‡ contributions cancel separately. The flow agent owns an explicit freeActionVertices list; the QFT agent owns coefficient extraction of this same S0.

## Bare coupling and mixing normalization: exact textbook source

Itzykson–Zuber printed p593, eqs(12-124)–(12-126), decomposes the Ward-restored action into gluon kinetic coefficient Z3, cubic gZ1, quartic g²Z4, ghost kinetic Ztilde3 and ghost vertex gZtilde1. It fixes

`A0=sqrt(Z3) A`, `c0=sqrt(Ztilde3)c`, `cbar0=sqrt(Ztilde3)cbar`,

`g0=g Z1/(Z3)^(3/2)`, `λ0=λ/Z3`.

The ST constraints are

`Z1/Z3=Ztilde1/Ztilde3=Z4/Z1`.

Thus `g0=g Ztilde1/(Ztilde3 sqrtZ3)=g sqrtZ4/Z3` as well. All roots and reciprocals are unit formal-series operations with constant coefficient1. No arbitrary root branch is permitted. Printed pp600–603, eqs(12-157)–(12-168), gives the all-order local counterterm decomposition; p604 repeats the universality ratios to all orders.

One must extract Z3 from the quadratic action **including S0**, Z1 from the cubic coefficient divided by g, and then divide out the gluon wavefunction factors. The raw cubic coefficient alone is not g0. Composite matrices likewise come from actual insertion jet coefficients and their unit formal inverse, with dimension/tensor/ghost constraints.

This textbook decomposition is a Ward-preserving renormalization presentation. A raw finite-cutoff flow action also contains BRST-breaking local counterterms, so projecting one of its coefficients and naming it Z1 does not prove this decomposition. A finite scheme transport and Ward-restored decomposition, including gauge-fixing/shifted-B/antifield rescalings, is required to identify the bare coordinates. Until that bridge is encoded, beta/gamma derived from arbitrary g0/Z inputs would remain disconnected.
