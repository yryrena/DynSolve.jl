# Solvers/PerturbationSolver.jl

"""
    PerturbationSolver()

Placeholder solver type for linearized (perturbation) methods.
"""
struct PerturbationSolver
end

"""
    solve(sys::Dict, ::PerturbationSolver) -> Dict

Pretend to solve the linearized model and return policy objects.
"""
function solve(sys::Dict, ::PerturbationSolver)
    @info "Solving linearized model (perturbation placeholder)..."
    return Dict(
        :G1     => [0.95],
        :impact => [0.1],
    )
end