# Urgent smoothness-order correction

The pinned mathlib's ContDiff order is `WithTop ℕ∞`, with TWO infinite
orders. `∞` is the coercion of the inner `ℕ∞` top and means C-infinity.
The outer `⊤`, also written `ω`, requires analyticity. See
Mathlib/Analysis/Calculus/ContDiff/Defs.lean, notation paragraph and definition
of ContDiffWithinAt. Consequently `ContDiff ℝ ⊤ f` is not the intended
ordinary smoothness assumption.

The PRIMARY tree audit finds 45 affected declarations in 18 files; exact
pre-patch file/line inventory is SMOOTH_ORDER_AUDIT.json. Replace ALL these
outer orders by `∞`. There is no primary-source justification for requiring
real-analytic momentum, joint coupling/momentum, finite-renormalization
scale/germ, quantum lift, or exact stress regular numerator data. FHH/FH
work coefficientwise at arbitrary fixed order and use smooth momentum
Taylor reconstruction, not an analytic germ identity theorem. IZ treats
perturbative expansions as formal/asymptotic; the Clay source explicitly
warns in §6.1 that ordinary perturbation expansions generally diverge.

The most direct extra restriction is on `dict.exactRegular`: an analytic
germ cannot carry a nonzero flat correction such as exp(-1/g^2), extended
by zero at g=0, whereas a smooth asymptotic completion can. Arbitrary formal
jets can have zero radius of convergence and admit smooth realizations;
analytic realizations cannot. Do not respond by proving or requiring that
these exact completions happen to be analytic.

Qualification: some fixed-loop g families already satisfy an exact graph
homogeneity law, making their g dependence polynomial. In those particular
slots analytic-g may be redundant, rather than itself an exclusion of a
divergent all-loop series. This does not justify analytic momentum or
joint regularity, and it does not repair the exact stress/scheme germ
restriction. Uniform replacement expresses the intended hypothesis and
avoids accidentally relying on this stronger order in proofs.

Do NOT globally replace every top symbol. Examples
`(show (1 : ℕ∞) + k ≤ ⊤ from le_top)` in FiniteJetDeterminacy and
`(d.length : ℕ∞) ≤ ⊤` in IntegratedMarginalFlow concern the INNER
ℕ∞ top and correctly express finite order below infinity. They are proof
inequalities, not analyticity assertions. Likewise the modulus of an
explicitly typed `(⊤ : ℕ∞)` coerces to the correct smooth order.

After replacement, rebuild the dependent modules and inspect any proof
failure rather than strengthening a hypothesis back to analyticity.
AnchoredCoordinateDeterminacy already assumes actual ContDiff ℝ ∞ and its
proof uses finite jets; the new canonical high-PDE result does not require
analyticity. The previous assembled-scope review is CONDITIONAL on this
concrete correction: the unpatched candidate does have an unjustified
extra condition and should not be accepted as-is.
