# Linearization.jl
# Placeholder linearization utilities

using LinearAlgebra

"""
    linearize(model, ss; order::Int=1)

Placeholder linearization routine.
Returns dummy system matrices A, B.
"""
function linearize(model, ss; order::Int=1)
    @info "Linearizing model (order = $order)..."
    return Dict(:A => [0.9], :B => [0.1])
end