module SteadyState

using NLsolve, LinearAlgebra
import ..ModelSpec: Model

"""
    steadystate(model::Model)

Compute steady-state of the model automatically.
"""
function steadystate(model::Model)
    @info "Computing steady state..."
    ## placeholder: will extract steady-state equations and call NLsolve
    return Dict(:k => 1.0, :c => 0.5, :y => 1.0)
end

end   ## module