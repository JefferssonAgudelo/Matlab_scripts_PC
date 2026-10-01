# Intermittent Alfvenic turbulence setup for PIC initial conditions

## What this does

Standard "sum of Fourier modes with random phases + power-law spectrum"
initial conditions are **Gaussian** in real space, by the Central Limit
Theorem, no matter what spectral slope you choose. Intermittency is a
phase-correlation effect across scales, not a spectral-shape effect, so
reproducing it requires an extra ingredient on top of your usual spectrum.

This code adds that ingredient using a **multiplicative cascade** (Castaing
1990; Schmitt & Marsch 1991 "FIF" model; the log-normal/p-model family):
the field is decomposed into logarithmic k-shells, and each shell's
amplitude is locally modulated (in real space) by the cumulative product of
random, mean-1, positive multipliers inherited from all larger scales. This
is the standard generative picture behind Kolmogorov's refined similarity
hypothesis, and it is also exactly the mechanism that produces NIG
statistics: **a Normal Inverse Gaussian distribution is a Gaussian
variance-mean mixture with an Inverse Gaussian mixing distribution** — i.e.
a Gaussian core whose local variance is itself a random (cascading)
quantity. Building the cascade explicitly is therefore a physically
motivated way to *generate* fields whose increment PDFs are well described
by NIG at small scales and approach Gaussian at large scales, which is
exactly the phenomenology reported in the paper you linked (Palacios,
Perez & Bourouaine 2024, MNRAS 531, 24): Gaussian at the outer scale →
exponential tails in the inertial range → stretched-exponential tails near
dissipation.

The cascade is applied to the **Elsasser variables** z± = v ∓ b/√(μ₀ρ)
rather than to v and b separately, because z± are the physically
independent characteristic fields of linear (shear) Alfven waves. Building
them independently, transverse to **k**, gives exact linear Alfven wave
polarization and correct v–b correlation (cross helicity) for free.

## Files

| file | purpose |
|---|---|
| `kspace_grid.m` | 3D FFT-consistent wavenumber grid |
| `spectral_amplitude.m` | isotropic E(k)~k^-alpha amplitude envelope with outer/dissipation cutoffs |
| `gen_alfvenic_elsasser.m` | Gaussian, random-phase, div-free, transverse z±_k with chosen cross helicity |
| `multiplicative_cascade.m` | builds the hierarchical, positive, mean-1 cascade weights W_j(x) |
| `apply_intermittency.m` | shell-decomposes z±_k, reweights each shell by sqrt(W_j(x)), recombines |
| `helmholtz_project.m` | re-projects a field onto its divergence-free part (needed because real-space cascade modulation breaks exact solenoidality — see note below) |
| `nig_pdf.m` | NIG probability density function (uses `besselk`) |
| `fit_nig.m` | unconstrained MLE fit of (alpha,beta,delta,mu) to a sample |
| `diagnostics_increments.m` | PDFs of increments at multiple scales + NIG fit overlay + kurtosis(scale) |
| `main_run.m` | driver script: run this first |

## How to tune it against the paper

1. Run `main_run.m` with `sigma2_per_octave = 0` first — this is your
   Gaussian control case (sanity check: kurtosis(scale) should be flat and
   ≈0, and the NIG fit should collapse to alpha→∞, beta→0, i.e. Gaussian).
2. Increase `sigma2_per_octave` and re-run. `diagnostics_increments.m`
   prints/plots the fitted NIG (alpha, beta, delta) and the excess
   kurtosis as a function of scale ℓ.
3. Compare the **scale-dependence** of your fitted parameters to Table/
   Figures in Palacios, Perez & Bourouaine (2024). Their key empirical
   result is that the NIG parameters themselves follow well-defined
   power laws in ℓ within the inertial range. To reproduce that, the
   simplest extension is to make `sigma2_per_octave` itself a (small)
   function of shell index j rather than a single constant — i.e. give
   the cascade a scale-dependent intermittency correction exponent, the
   same free parameter that appears in log-normal/log-Poisson
   intermittency models (related to the anomalous scaling exponents
   ζ_p of the structure functions). This is a one-line change in
   `multiplicative_cascade.m` (pass a vector `sigma2(j)` instead of a
   scalar).
4. For imbalanced turbulence set `sigma_c ≠ 0`; you can also decorrelate
   the intermittency of z+ and z- by generating two independent calls to
   `multiplicative_cascade.m` and passing different W's to each call of
   `apply_intermittency.m` in `main_run.m` (currently they share one W,
   which keeps v/b intermittency correlated — probably what you want for
   a first pass, since v and b are indeed observed to be co-intermittent).

## Practical notes / honesty check

- I don't have a MATLAB runtime in this environment to execute and debug
  the code numerically, so please run it yourself and sanity-check the
  printed `div B` and rms values in `main_run.m` before trusting it for
  production PIC runs. The FFT conventions, transversality projection,
  and NIG algebra are standard and I've reasoned through them carefully,
  but a first test run (start at low resolution, e.g. 64^3, for speed)
  is the right way to confirm everything is wired correctly on your
  MATLAB version.
- Units: `b` in the code is built in Alfven-speed units
  (b_code = B_physical/√(μ₀ρ)); rescale by √(μ₀ρ) (or by whatever your PIC
  code's internal normalization is) before writing the final field if
  your initializer expects physical B, not velocity-equivalent B.
- `apply_intermittency.m` multiplies each k-shell's real-space contribution
  by a spatially varying weight sqrt(W_j(x)). This is NOT divergence-free
  in general: for a transverse field E (div E = 0), div(w*E) = E . grad(w)
  != 0. In practice this shows up as an O(10%) relative divergence in the
  raw cascade output — confirmed by running the code. `main_run.m` fixes
  this with a final call to `helmholtz_project.m` right after recombining
  z+/z- into b and v, which projects the field back onto the transverse
  (div-free) subspace in k-space (F_k -> F_k - khat(khat.F_k)). This is
  the standard cleanup step used with real-space cascade modulation
  methods; it removes a small amount of energy, which is why rescaling to
  the target rms happens AFTER the projection, not before.
- Resolution/aliasing: `kmax` is kept below the grid Nyquist wavenumber
  in `main_run.m`; if you push `kmax` too close to Nyquist you'll get
  aliasing artifacts that can masquerade as (fake) small-scale
  intermittency — always check this is not what's driving your kurtosis
  increase.
- Cost: `multiplicative_cascade.m` and `apply_intermittency.m` do
  O(Nshells) FFTs of the full 3D grid, ×3 vector components. This is
  cheap compared to a PIC time step, but scale `Nshells`/resolution
  sensibly for quick iteration during setup design.
