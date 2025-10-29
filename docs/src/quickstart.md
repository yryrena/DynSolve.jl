# Quickstart

This guide walks you through installing and using `DynSolve.jl` for the first time.

---

## Installation

`DynSolve.jl` is a Julia package. You can develop it locally or install from source once published.

```julia
using Pkg
Pkg.add(url="https://github.com/yryrena/DynSolve.jl")

If you are developing locally (recommended for research):

```{bash}
cd /path/to/DynSolve
julia --project=.
```

Then in the Julia REPL:

```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

## Basic Usage Example

The following minimal script runs the entire DynSolve workflow on a simple RBC model:

```julia
using DynSolve

model = @dgesys begin
    var c(t), k(t), y(t), r(t)
    shock εA(t)
    param α=0.36, β=0.99, δ=0.025, ρA=0.9, σA=0.01

    y(t)   ~ exp(a(t)) * k(t)^α
    a(t+1) ~ ρA * a(t) + σA * εA(t)
    Euler  ~ 1/c(t) ~ β * (1/c(t+1)) * (1 + r(t+1) - δ)
    k(t+1) ~ y(t) - c(t) + (1-δ)*k(t)
    r(t)   ~ α * y(t)/k(t)
end

ss  = steadystate(model)
lin = linearize(model, ss)
sol = solve(lin, PerturbationSolver())
irf = impulse_response(sol; shock=:εA)
report = analyze(model, ss, sol, irf)
export_report(report, "rbc_report.md")
```

## Directory Overview

A typical DynSolve project contains: 

```{bash}
DynSolve/  
├── Project.toml
├── Manifest.toml
├── README.md
├── LICENSE
├── src/            ## core package source
├── test/           ## automated tests
├── examples/       ## runnable model demos
├── docs/           ## documentation (Documenter.jl)
├── scripts/        ## benchmarks / figures / experiments
└── .gitignore
```
 

## Next Steps
- See [Model Specification](api/model.md) for the `@dgesys` macro.  
- Try [RBC Example](examples/rbc.md) and [NK Example](examples/nk.md).  
- Explore different solvers in [Solvers](api/solvers.md).
 
 