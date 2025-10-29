# Example: Real Business Cycle (RBC) Model

This page demonstrates how to define and solve a simple **RBC model** using DynSolve.jl.


## Model Definition

```julia
using DynSolve

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


## Steady State

```julia
ss = steadystate(model)
```

Outputs (placeholder):

```julia
Dict(:k => 1.0, :c => 0.5, :y => 1.0)
```

## Linearization and Solution

```julia
lin = linearize(model, ss)
sol = solve(lin, PerturbationSolver())

```

## Impulse Response Functions

```julia
irf = impulse_response(sol; shock=:εA)
```

## Report Generation

```julia
report = analyze(model, ss, sol, irf)
export_report(report, "rbc_report.md")
```

## Interpretation

Even though this example uses placeholder numbers, the workflow mirrors a full RBC model pipeline:
- symbolic model specification
- automated steady-state computation
- linearization
- perturbation solution
- IRFs and reporting
 