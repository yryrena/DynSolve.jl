# SteadyState.jl

"""
    steadystate(model) -> Dict

Placeholder steady state solver.
Currently returns dummy values.
"""
function steadystate(model)
    @info "Computing steady state (placeholder)..."
    return Dict(
        :k => 1.0,
        :c => 0.5,
        :y => 1.0,
    )
end