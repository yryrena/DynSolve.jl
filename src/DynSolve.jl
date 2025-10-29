module DynSolve

## public API  
export steadystate,
       linearize,
       solve,
       impulse_response,
       analyze,
       export_report,
       PerturbationSolver,
       ProjectionSolver,
       VFISolver

using LinearAlgebra
using Random
using Plots
 
include("SteadyState.jl")
include("Linearization.jl")
include("Analysis.jl")
include("Report.jl")

include("Solvers/PerturbationSolver.jl")
include("Solvers/ProjectionSolver.jl")
include("Solvers/VFISolver.jl")

end   ## module