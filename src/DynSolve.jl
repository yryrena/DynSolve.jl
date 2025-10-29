# src/DynSolve.jl
module DynSolve

using LinearAlgebra
using Random
using Plots
using PrettyTables

include("ModelSpec.jl")
include("SteadyState.jl")
include("Linearization.jl")
include("Solvers/PerturbationSolver.jl")
include("IRF.jl")
include("Analysis.jl")
include("Report.jl")

export @dgesys,
       var,
       param,
       equation,
       Model,
       steadystate,
       linearize,
       solve,
       impulse_response,
       analyze,
       export_report,
       PerturbationSolver

end    ## module DynSolve