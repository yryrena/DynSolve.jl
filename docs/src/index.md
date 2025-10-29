# DynSolve.jl

`DynSolve.jl` is a Julia toolkit for defining, solving, and analyzing dynamic macroeconomic models
(DSGE / RBC / New Keynesian / heterogeneous agent). The goal is to let you:

- Specify a model in symbolic form (variables, shocks, equilibrium conditions).
- Automatically compute steady states.
- Linearize (or higher-order expand) around the steady state.
- Solve for decision rules using perturbation, projection, or value function iteration.
- Generate impulse responses, simulations, and summary reports.

DynSolve aims to be an open, high-performance alternative to traditional MATLAB/Octave-based tools
(e.g. Dynare) with native Julia performance and integration with ModelingToolkit.jl.

## Quick Example

```julia
using DynSolve

## 1. define a model
model = @dgesys begin
    var c(t), k(t), y(t), r(t)
    shock εA(t)
    param α=0.36, β=0.99, δ=0.025, ρA=0.9, σA=0.01

    y(t)      ~ exp(a(t)) * k(t)^α
    a(t+1)    ~ ρA * a(t) + σA * εA(t)
    Euler     ~ 1/c(t)    ~ β * (1/c(t+1)) * (1 + r(t+1) - δ)
    k(t+1)    ~ y(t) - c(t) + (1-δ)*k(t)
    r(t)      ~ α * y(t)/k(t)
end

## 2. compute steady state
ss = steadystate(model)

## 3. linearize around steady state
lin = linearize(model, ss; order=1)

## 4. solve (e.g. perturbation / Blanchard-Kahn style)
sol = solve(lin, PerturbationSolver())

## 5. get IRFs
irf = impulse_response(sol; shock=:εA, horizon=40)

## 6. analyze and export report
report = analyze(model, ss, sol, irf)
export_report(report, "rbc_report.md")
```

This workflow is designed to mirror the typical DSGE workflow:
- write FOCs / equilibrium conditions once 
- get steady state, policy functions, impulse responses automatically 
- produce a structured report that you can drop into a paper or presentation 

Design Goals
- Symbolic first. Models are declared as symbolic systems using `ModelingToolkit.jl`. That means we can take Jacobians, compute steady states, and generate code automatically.
- Fast. Julia-level performance close to C, without MATLAB/Octave licensing.
- Extensible. Projection methods and value function iteration are first-class, so heterogeneous agent and occasionally binding constraint models are not an afterthought.
- Reproducible. The entire analysis pipeline (steady state → IRFs → report)
is scripted and version-controlled, not hidden in a notebook.

Status
- `DynSolve.jl` is under active development. Some solvers are stubs or illustrative placeholders.
The public API is being stabilized around:
- `@dgesys` : model declaration macro
- `steadystate` : steady state computation
- `linearize` : symbolic linearization / perturbation
- `solve` : numeric solution (multiple solver backends)
- `impulse_response` : IRFs
- `analyze` : summary stats and diagnostics
- `export_report` : markdown / HTML reporting

You are encouraged to prototype, extend, and open issues.