# Actual fixed flow uniqueness and normalization correction

This tranche proves properties of the fixed group-specific prescription.
It does not prove nonperturbative existence or admit the full target.

## Uniqueness of the same background

`CoefficientFlowConditions.unique` proves equality of any two actual
background families with the SAME e and local marginal data, throughout
0 < Lambda <= UV and 0 < mu <= UV. The proof uses exactly the nonlinear
backgroundFlowRHS, the two-point-free tree interaction, reduced conserving
momenta and the actual mixed normalization boundaries.

`FlowTriangularity` proves the actual finite contractions are lower in loop
order, or in arity at equal loop order; the apparent exceptions multiply a
vanishing free tree coefficient. `FlowScaleConstancy` applies the zero
actual derivative theorem on positive intervals, with continuity at UV.
`FlowBoundaryUniqueness` fixes the resulting difference: relevant jets vanish
by the actual IR limit, marginal jets agree at mu, and all higher jets vanish
at UV. `FiniteJetDeterminacy` and `ReducedMomentumDeterminacy` reconstruct
zero by finite derivative descent and multilinearity on actual momentum
coordinates. No analyticity or convergence of an infinite Taylor series is
assumed. No uniqueness clause is added to candidate data.

`CoefficientFlowConditions.dimensional_covariance` then identifies the
CHOSEN background with the actual rescaled family, because transformed
conditions and their uniqueness are proved. The positive-cutoff domain is
explicit; continuum limits must be transported using their actual limits.

## Whole coupled insertion system

`InsertionProjectorWeights` proves the exact ordered jet/projector weights.
`InsertionBoundaryDilation` and `OversubtractionBoundaryDilation` transport
all normalization and subtraction boundaries, including phases and positions.
`InsertionContractionDilation` and `InsertionSourceDilation` prove the actual
integrated contractions and pair/spectator source scaling with all signs,
source degrees, sorted spectator maps and the four-dimensional Jacobian.
`InsertionFlowConditions.rescale` and `FixedFlowSystem.dilate` construct the
whole rescaled system for the SAME group/e/local scheme. This establishes
covariance of the defining system. Equality of chosen insertion solutions,
regulated/continuum OPE coefficients and Ward/lift/CS data requires their
corresponding uniqueness or transport proofs; it is not silently inferred.

## Correct source integrated restoration

FHH1511.09425, Table II (printed p.21), Eq. (94), and especially Eq. (123)
(printed p.27) distinguish integrated insertions from the spatial integral of
pointwise insertions because their boundary conditions differ. A dimension-
four integrated response keeps zero relevant IR jets, with its marginal seed
at mu. This correction avoids an unnecessary broadening of the massless
background class.

`IntegratedMarginalFlow` defines this same-background homogeneous response.
Its leading finite change preserves actual relevant IR zero and computes the
marginal change. The true UV correction is its response endpoint, including
induced counterterms. `raw_boundary_iff` proves that replacing it by a raw
polynomial requires the exact endpoint equality; that equality is not
assumed. The dimension-five integrated BRST response, finite triangular
pointwise normalization bridge and nonlinear higher-order reflow remain work.
The older raw `RestorationStep` is retained as a comparison whose extra
endpoint condition is explicit; it is not certified as source-equivalent.

## Same-action antifields and coupling

The compact ghost-antifield and shifted gauge-antifield equations now use the
actual same-action curvature Euler derivative and the fixed shifted source
K=A-antifield+partial(antighost)-i partial(B-antifield). All source/ghost/current
terms and signs are proved. `GraphRescalingZero` proves the actual graph-
homogeneous deformation and primitive identities at ALL real g, including
zero, with nonnegative powers for positive loop order. These identities do not
replace the remaining formal nonabelian cohomological classification or the
last interacting antifield nilpotency equations.
