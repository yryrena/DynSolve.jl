#!/usr/bin/env julia
#
# Scratchpad for experimenting with projection / collocation methods.
# This script is NOT part of the stable API.
#
# Usage:
#   julia --project=. scripts/experiment_projection.jl
#
using DynSolve

println("=== DynSolve projection-method experiment ===")

## define a toy model that is typically solved with projection methods,
## e.g. a model with occasionally binding constraints 
model = @dgesys begin
    var c(t), k(t), y(t)
    shock εA(t)
    param α=0.36, β=0.95, δ=0.08, ρA=0.9, σA=0.02

    y(t)      ~ exp(a(t)) * k(t)^α
    a(t+1)    ~ ρA * a(t) + σA * εA(t)

    ## resource constraint
    k(t+1)    ~ y(t) - c(t) + (1-δ)*k(t)

    ## euler condition with "soft borrowing constraint" idea (placeholder):
    Euler     ~ 1/c(t) ~ β * (1/c(t+1)) * (α * y(t+1)/k(t+1) + 1 - δ)
end

println("Attempting steady state...")
ss = steadystate(model)
println("Steady state guess: ", ss)

println("Attempting nonlinear solution via ProjectionSolver() ...")
proj_sol = solve(model, ProjectionSolver())

println("Result from ProjectionSolver(): ", proj_sol)
println("NOTE: ProjectionSolver is currently a placeholder. This script is for method development.")
println("Done!!")