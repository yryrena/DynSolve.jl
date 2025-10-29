# IRF.jl
# Impulse responses

using LinearAlgebra
using Random
using Plots

"""
    impulse_response(solution; shock, horizon=40)

Placeholder IRF generator (simple exponential decay).
Returns a Dict like Dict(:y => [1.0, 0.9, 0.81, ...])
"""
function impulse_response(solution; shock::Symbol, horizon::Int=40)
    @info "Computing IRFs for $shock..."
    vals = exp.(-0.1 .* (0:horizon-1))
    return Dict(:y => vals)
end
