using Test
using DynSolve

@testset "Solvers dispatch" begin
    dummy_lin = Dict(:A => [0.9], :B => [0.1])

    sol1 = solve(dummy_lin, PerturbationSolver())
    @test isa(sol1, Dict)
    @test haskey(sol1, :G1)

    sol2 = solve(dummy_lin, ProjectionSolver())
    @test sol2 === nothing     ## currently unimplemented

    sol3 = solve(dummy_lin, VFISolver())
    @test sol3 === nothing     ## currently unimplemented
end