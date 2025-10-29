module Solvers
 
include("PerturbationSolver.jl")
include("ProjectionSolver.jl")
include("VFISolver.jl")
 
using .PerturbationSolver: PerturbationSolver, solve as solve_perturbation
using .ProjectionSolver: ProjectionSolver, solve as solve_projection
using .VFISolver: VFISolver, solve as solve_vfi

"""
    solve(system, solver)

Dispatch entry point for all solver types.

Depending on the solver type, forwards to the correct method:
- `PerturbationSolver()`
- `ProjectionSolver()`
- `VFISolver()`
"""
function solve(system, solver)
    if solver isa PerturbationSolver
        return solve_perturbation(system, solver)
    elseif solver isa ProjectionSolver
        return solve_projection(system, solver)
    elseif solver isa VFISolver
        return solve_vfi(system, solver)
    else
        error("No solver available for type $(typeof(solver))")
    end
end

export PerturbationSolver, ProjectionSolver, VFISolver, solve

end   ## module