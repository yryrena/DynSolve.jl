using DynSolve

"""
projection method demo 

The projection solver is intended for nonlinear models that are poorly
approximated by local perturbation (e.g. models with occasionally binding
constraints, large shocks, or global dynamics).

This demo uses a toy RBC-like model. The ProjectionSolver() is currently a
placeholder and will return `nothing`. The purpose of this file is to show
the intended workflow and to serve as a development testbed.
"""

proj_model = @dgesys begin
    var c(t), k(t), y(t)
    shock εA(t)

    param α=0.36, β=0.96, δ=0.08, ρA=0.9, σA=0.02

    y(t)      ~ exp(a(t)) * k(t)^α
    a(t+1)    ~ ρA * a(t) + σA * εA(t)

    ## capital accumulation with depreciation
    k(t+1)    ~ y(t) - c(t) + (1-δ)*k(t)

    ## euler condition for optimal savings
    Euler     ~ 1/c(t) ~ β * (1/c(t+1)) * (α * y(t+1)/k(t+1) + 1 - δ)
end

println("Computing steady state (for initialization purposes)...")
proj_ss = steadystate(proj_model)
println("proj_ss = ", proj_ss)

println("Attempting global solve via ProjectionSolver() ...")
proj_solution = solve(proj_model, ProjectionSolver())

println("Projection solver output: ", proj_solution)
println("(Currently unimplemented: expect `nothing`.)")

println("Done!!")