#!/usr/bin/env julia
#
# Generate standard figures (IRFs, etc.) for a given model.
#
# Usage:
#   julia --project=. scripts/generate_figures.jl
#
using DynSolve
using Plots

println("=== DynSolve figure generation ===")

## define the model
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

## solve pipeline
ss  = steadystate(model)
lin = linearize(model, ss)
sol = solve(lin, PerturbationSolver())
irf = impulse_response(sol; shock=:εA, horizon=40)

println("IRF keys: ", keys(irf))

## pot an example IRF (e.g. output y)
if haskey(irf, :y)
    irf_y = irf[:y]
    tgrid = 0:length(irf_y)-1

    plt = plot(
        tgrid, irf_y,
        xlabel = "Periods",
        ylabel = "Response",
        title = "IRF of y to εA shock",
        legend = false,
    )

    savefig(plt, "fig_irf_y.png")
    println("Saved figure: fig_irf_y.png")
else
    println("No :y key found in IRF dictionary, skipping figure export.")
end

println("Done!!")