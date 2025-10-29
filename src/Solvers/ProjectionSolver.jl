# ProjectionSolver.jl
# Placeholder for global projection / collocation methods

"""
    ProjectionSolver()

Represents a global/projection solver (Chebyshev, collocation, etc.).
"""
struct ProjectionSolver end

"""
    solve(model, ::ProjectionSolver)

Placeholder for projection method solver.
Currently unimplemented.
"""
function solve(model, ::ProjectionSolver)
    @info "Projection solver not yet implemented"
    return nothing
end