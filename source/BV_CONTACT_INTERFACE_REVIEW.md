# Central interface adversarial review

Reviewed the PRIMARY snapshot of ClassicalPointContact, CollisionScaling,
RegulatedBVFlow/RegulatedWardInsertion, ContactTaylorProjection,
ContactAnomalyTransport, QuantumObservableLift/QuantumOutputRecovery,
GeneratedEuclideanCoefficients and GeneratedMultiMatching. No root files edited.

## Concrete findings

1. **Same-flow W binding was absent (P1, root has now fixed).**
   GeneratedEuclideanData.Compatible at line 85 and QuantumPhysicalOutputRecovery
   at line 106 accepted W without W.BulkCompatible for S.insertions and
   S.oversubtractions. lift.LimitCompatible fixes corrected invariant single
   insertions only. It cannot identify all raw monomial, wardSingle and
   background components used in recovery. Root reports adding mandatory
   `same_flow_continuum`; this is the correct fix.

2. **Contact admission remains incomplete (P1 until the new multi-Ward bundle
   is wired).** GeneratedMultiSectorConditions line 24 did not require the
   computed A2 transport, its coefficient limits, multi-insertion Ward identities,
   Jacobi/compatibility, or a contact extension condition. raw_limit and
   physical_recovery in GeneratedEuclideanCoefficients only test off diagonals.
   Delta derivatives within the scaling-degree bounds can therefore be changed
   without these equations detecting them. CollisionScaling correctly bounds
   extensions but cannot determine their Ward-compatible finite local part.
   Source: FHH 1511.09425 (335), (340), (346), pp.64–66, and the subsequent
   decomposition/consistency argument. Root reports qft is implementing this.

3. **Recovery is not yet a physical cohomology/null-state theorem (P1 before
   full specification admission).** QuantumOutputRecovery lines 106ff correctly
   allows a same-Q exact local remainder; it does not show that this remainder
   vanishes between physical BRST states or that physical matrix elements
   separate the permitted cohomology quotient. Arbitrary W-null directions can
   otherwise underdetermine outgoing physical coordinates. Add the actual
   same-dictionary map to the physical Wightman domain, Q-exact nullness there,
   and a stated quotient separation/generation condition. Do not impose Q-image
   nullness on arbitrary elementary external-leg W tests: the source Ward
   identity has a nonzero free ST action on those external legs. Root owns this.

4. **Quantum lift finite normalization remains a scheme choice.**
   QuantumObservableLift.Compatible fixes tree data, support, cocycle and graph
   grading but permits finite higher-loop cohomology mixing, e.g. multiplication
   of a cocycle by 1+c*hbar*g^2. This is legitimate renormalization freedom; it
   is not a uniquely fixed prediction basis. Either give a fixed higher-loop
   cohomology normalization/projection, or explicitly retain it as a finite
   physical scheme transformation and transport beta/gamma and stress in that
   same scheme. Do not infer uniqueness from the tree normalization.

## Source signs and degrees checked

* ClassicalPointContact line 38 has the correct partner pairing and minus sign
  for an antifield in its first slot. The derivative signs follow from
  d_y^beta delta=(-d_x)^beta delta and
  B(y)d_x^gamma delta=sum_(nu<=gamma) binom(gamma,nu) D^nuB(x)
  d_x^(gamma-nu)delta. In its first-centered convention, testing d_x^alpha
  delta with a coefficient at x gives +D_y^alpha f(x,x), as line 66 implements.
* ContactTaylorProjection line 67 correctly expands the FINITE polynomial at
  p=kappa+k_right before combining partitions: source (338) contributes
  exp(-i(x-y)p) exp(+i(x-y)k_right). The coefficient is
  i^|alpha|/(alpha! nu!) k_right^nu D^(alpha+nu)K(0), with
  |alpha|+|nu|<=r. The (2*pi)^-4 factor belongs to the Fourier integral, not
  the polynomial Taylor coefficient. Source (346)'s displayed line suppresses
  this i-power under its printed ordinary-derivative notation; the explicit
  exp(-irp) convention fixes it.
* RegulatedBVFlow lines 20, 27, 67 agree with (290)–(294), pp.56–57:
  D_R,zF=(-1)^(p(z)(p(F)+1))D_L,zF; the R^-1 kinetic factor cancels R only
  for the kinetic field-to-antifield part, while free antifield couplings
  retain R; Delta differentiates right antifield first then left basic.
  The action defect has 1/2 bracket and hbar Delta (one-loop shift), whereas
  a single insertion defect has the full bracket and its intrinsic parity.
* A2 support C.dim+|alpha|+3<=A.dim+B.dim, ghost +1, parity +1 is correct.
  The graph exponent n_C+2+2l-n_A-n_B is correct: one field/antifield pair
  removes two legs. Guarding negative powers before natural subtraction is
  essential and the current code does it.
* Quantum recovery's primitive bound dim(primitive)+1<D is correct when
  outgoing fields have dim<D. Q's full filtration/ghost support prevents
  higher outgoing degrees from hiding outside the tested finite rectangle.
* CollisionScaling uses the correct transverse codimension 4(|S|-1), keeps
  cluster center/spectators fixed, and subtracts output degree only for the
  total collision. The conservative proper-subcluster bound is sufficient,
  though it does not classify all extensions. No new sign defect found.

## Still supporting mathematical obligations

The exact jet-density/ordered-amplitude bridge is now proved in
FullBVBridge.lean. Remaining source-fidelity proofs include normalized jet
basis reconstruction and weighted degree bounds for boundedDensityInsertion;
Euler/regulated-BV coefficient equivalence and the actual master equation;
local-functional divergence descent; contact extension/transport and physical
cohomology. These are not consequences of compilation alone.
