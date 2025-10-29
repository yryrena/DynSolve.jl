# PerturbationSolver.jl
# Lightweight linear(ized) DSGE solver placeholder

"""
    PerturbationSolver()

Represents a linear DSGE/RBC perturbation-method solver (e.g. Blanchard-Kahn).
"""
struct PerturbationSolver end

"""
    solve(linearized_system::Dict, ::PerturbationSolver)

Placeholder perturbation solver.
Returns fake policy matrices to demonstrate API.
"""
function solve(linearized_system::Dict, ::PerturbationSolver)
    @info "Solving linearized model (perturbation placeholder)..."
    return Dict(:G1 => [0.95], :impact => [0.1])
end