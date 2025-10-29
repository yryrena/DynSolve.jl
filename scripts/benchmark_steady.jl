#!/usr/bin/env julia
#
# Benchmark the steady state solver on a representative model.
# Usage:
#   julia --project=. scripts/benchmark_steady.jl
#
using DynSolve
using Dates

println("=== DynSolve steady state benchmark ===")
println("Timestamp: $(now())")

## define a simple RBC-style model
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

println("Solving steady state...")

t0 = time()
ss = steadystate(model)
t1 = time()

println("Steady state result (truncated):")
println(ss)
println("Time elapsed: $(round(t1 - t0, digits=6)) seconds")

println("Done!")