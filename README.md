# DynSolve.jl

[![CI](https://github.com/yryrena/DynSolve.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/yryrena/DynSolve.jl/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://yryrena.github.io/DynSolve.jl/)



`DynSolve.jl` is a Julia package for automated solution and analysis of dynamic general equilibrium models (RBC / DSGE / NK / HANK).

It aims to be an open, high-performance alternative to Dynare (MATLAB), written entirely in Julia. The design is meant to integrate with `ModelingToolkit.jl` and generic SciML tooling going forward.

---

## Project Status

`DynSolve.jl` is an early prototype (`v0.1.0`).

- The core pipeline (`steadystate → linearize → solve → IRF → report`) runs end-to-end and is tested in CI.
- The `@dgesys` macro exists and can build a `Model` struct (variables, parameters, equations) from a small DSL.
- `steadystate`, `linearize`, `solve`, `impulse_response`, `analyze`, and `export_report` all run (currently some are placeholders / simplified).
- Nonlinear global solvers (projection / collocation) and heterogeneous-agent solvers (VFI) are scaffolded but not fully implemented yet.
- Public API is not stable. Expect breaking changes.

Docs are evolving; see https://yryrena.github.io/DynSolve.jl/ for high-level overview.  


---
## Features

- Lightweight model container `Model` with

  - `variables::Vector{Symbol}`
  - `parameters::Dict{Symbol,Any}`
  - `equations::Vector{EquationData}`

- A working macro-based mini-DSL:

  ```julia
  model = @dgesys begin
      var(:c, :k)
      param(β = 0.99, δ = 0.025)
      equation(:Euler, :(1/c - β * (1/c) * (1 - δ)))
  end
  ```

- Placeholder steady state and linearization routines

- A perturbation-style `solve` step

- Impulse response calculation for named shocks

- Automatic Markdown report generation

- Clean package layout with tests and CI

The long-term goal is:

- higher-level symbolic equations (time indices like `c(t+1)`)
- automatic steady-state solving
- perturbation & global solvers
- heterogeneous-agent models
- calibration / analysis utilities
- strong ModelingToolkit.jl interoperability


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

using DynSolve
```

You should now be able to construct a model, run the pipeline, and generate a report.

------

## Minimal Working Example (current `@dgesys`)

```julia
using DynSolve

## define a toy model using @dgesys
m = @dgesys begin
    var(:c, :k)                  ## declares model variables
    param(β = 0.99, δ = 0.025)   ## parameters
    equation(:Euler, :(1/c - β * (1/c) * (1 - δ)))  # named equation
end

## m is a DynSolve.Model
m.variables      ## e.g. [:c, :k]
m.parameters     ## e.g. Dict(:β => 0.99, :δ => 0.025)
m.equations      ## vector of EquationData(name, expr)

## run the analysis pipeline (prototype / placeholder implementations)
ss  = steadystate(m)
lin = linearize(m, ss)
sol = solve(lin, PerturbationSolver())
irf = impulse_response(sol; shock = :εA, horizon = 40)
rep = analyze(m, ss, sol, irf)
export_report(rep, "rbc_report.md")
```

After running this, you should see a file `rbc_report.md` that looks like:

```markdown
# DynSolve Report
## Summary
Analysis complete
```

This demonstrates the full intended workflow: model definition → compute objects → analyze → export.

---

## Planned higher-level DSL (not implemented yet)

The goal is to support a richer, time-indexed, Dynare-style DSL:

```julia
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
```

This version would:

- track leads/lags like `c(t+1)`, `k(t)`, etc.,
- declare exogenous shocks,
- expand to first-order conditions,
- and feed solvers automatically.

This syntax is aspirational and **not fully available yet**.

The currently implemented DSL is the simpler form shown above  (`var(:c, :k)`, `param(...)`, `equation(...)`).

---

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

| Function                                     | Description                        |
| -------------------------------------------- | ---------------------------------- |
| `@dgesys`                                    | Build a `Model` from DSL           |
| `steadystate(model)`                         | Compute steady state (placeholder) |
| `linearize(model, ss)`                       | Linearize around SS (placeholder)  |
| `solve(system, PerturbationSolver())`        | Solve linearized system            |
| `impulse_response(solution; shock, horizon)` | Compute IRFs                       |
| `analyze(model, ss, sol, irf)`               | Basic summary stats                |
| `export_report(report, path)`                | Emit Markdown summary              |

------

## Solvers

Right now, the only solver that actually runs end-to-end in tests is:

- `PerturbationSolver()`    A basic perturbation / linear-solution placeholder.

The following are sketched but not yet complete:

- `ProjectionSolver()`   (planned; global / collocation / Chebyshev)
- `VFISolver()`          (planned; value function iteration / HANK)

---

## Building the docs locally

```
julia --project=docs docs/make.jl
```

The generated site will appear in `docs/build/`.

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
