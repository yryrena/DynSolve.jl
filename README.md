# DynSolve.jl

[![CI](https://github.com/yryrena/DynSolve.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/yryrena/DynSolve.jl/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://yryrena.github.io/DynSolve.jl/)


<<<<<<< HEAD
=======

>>>>>>> 686da0c (update)
`DynSolve.jl` is a Julia package for automated solution and analysis of dynamic general equilibrium (DGE / RBC / DSGE / NK / HANK) models.

It provides a unified workflow to:

- specify symbolic models (variables, shocks, equations)
- compute steady states
- linearize (and eventually nonlinear expand)
- solve using multiple backends (perturbation, projection, VFI)
- generate impulse responses and analysis reports

`DynSolve.jl` aims to be an open, high-performance alternative to **Dynare (MATLAB)**, built entirely in **Julia** and integrated with `ModelingToolkit.jl`.

---

## Project Status

`DynSolve.jl` is an early prototype (v0.1.0).  

- The core pipeline (`steadystate → linearize → solve → IRF → report`) runs end-to-end and is tested in CI.
- Some solvers (ProjectionSolver, VFISolver) and parts of the SteadyState/ModelSpec pipeline are still placeholders.
- The public API is not stable yet.

Full docs: https://yryrena.github.io/DynSolve.jl/

Build status: see CI badge below.


---
## Features

- clean modular design and working package structure
- automated steady-state, linearization, and perturbation placeholders
- impulse responses and simple Markdown reporting
- ready for integration with `ModelingToolkit.jl`
- extensible design for macroeconomic research and teaching


---
## Installation

For now, clone locally and develop:

```bash
git clone https://github.com/yryrena/DynSolve.jl
cd DynSolve.jl
julia --project=.
```

Then activate and instantiate the environment:

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

Once registered, you will be able to install via:

```julia
Pkg.add("DynSolve")
```

------

## Quick Example

For the current prototype (v0.1.0):

```JULIA
using DynSolve

fake_model = Dict(:placeholder => true)

ss  = steadystate(fake_model)
lin = linearize(fake_model, ss)
sol = solve(lin, PerturbationSolver())
irf = impulse_response(sol; shock=:εA, horizon=40)
rep = analyze(fake_model, ss, sol, irf)
export_report(rep, "rbc_report.md")
```

This generates `rbc_report.md` containing:

```markdown
# DynSolve Report
## Summary
Analysis complete
```

---

## Planned Symbolic Interface

The symbolic interface will allow users to define models using a DSL macro:

```julia
using DynSolve

## define model
model = @dgesys begin
    var c(t), k(t), y(t), r(t)
    shock εA(t)
    param α=0.36, β=0.99, δ=0.025, ρA=0.9, σA=0.01

    y(t)      ~ exp(a(t)) * k(t)^α
    a(t+1)    ~ ρA * a(t) + σA * εA(t)
    Euler     ~ 1/c(t) ~ β * (1/c(t+1)) * (1 + r(t+1) - δ)
    k(t+1)    ~ y(t) - c(t) + (1-δ)*k(t)
    r(t)      ~ α * y(t)/k(t)
end

## compute steady state
ss = steadystate(model)

## linearize around steady state
lin = linearize(model, ss)

## solve (perturbation)
sol = solve(lin, PerturbationSolver())

## impulse response
irf = impulse_response(sol; shock=:εA, horizon=40)

## report
report = analyze(model, ss, sol, irf)
export_report(report, "rbc_report.md")
```

------

## Directory Layout

```
DynSolve/
├── src/            ## core package source
├── examples/       ## example models (RBC, NK, HANK)
├── scripts/        ## benchmark and figure generation
├── docs/           ## documentation site (Documenter.jl)
├── test/           ## unit tests
└── Project.toml    ## dependencies and metadata
```

------

## Core API

| Function                                     | Description                 |
| -------------------------------------------- | --------------------------- |
| `@dgesys`                                    | Define a model symbolically |
| `steadystate(model)`                         | Compute steady state        |
| `linearize(model, ss)`                       | Symbolic linearization      |
| `solve(system, solver)`                      | Solve with chosen method    |
| `impulse_response(solution; shock, horizon)` | Compute IRFs                |
| `analyze(model, ss, sol, irf)`               | Summary statistics          |
| `export_report(report, path)`                | Save markdown/HTML report   |

------

## Available Solvers

| Solver                 | Description                                       |
| ---------------------- | ------------------------------------------------- |
| `PerturbationSolver()` | Linearized DSGE / RBC models (Blanchard–Kahn)     |
| `ProjectionSolver()`   | Nonlinear global methods (Chebyshev, collocation) |
| `VFISolver()`          | Value function iteration (heterogeneous agents)   |

------

## Documentation

Documentation is built with ``Documenter.jl`.

To build locally:

```julia
julia --project=docs docs/make.jl
```

The generated site will be available under `docs/build/`.

------

## Contributing

Contributions are very welcome! 

Areas particularly open for contribution:

- Projection / collocation solver implementation
- VFI (heterogeneous-agent) routines
- Steady-state symbolic solver improvements
- Model comparison and calibration utilities

---

## Acknowledgments

`DynSolve.jl` builds on the Julia ecosystem:

- [ModelingToolkit.jl](https://github.com/SciML/ModelingToolkit.jl)
- [NLsolve.jl](https://github.com/JuliaNLSolvers/NLsolve.jl)
- [Plots.jl](https://github.com/JuliaPlots/Plots.jl)
- [Weave.jl](https://github.com/JunoLab/Weave.jl)
