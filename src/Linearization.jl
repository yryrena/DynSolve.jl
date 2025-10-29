# Linearization.jl

"""
    linearize(model, ss) -> Dict

Placeholder linearization.
Returns dummy A,B matrices.
"""
function linearize(model, ss)
    @info "Linearizing model (order = 1)..."
    return Dict(
        :A => [0.9],
        :B => [0.1],
    )
end