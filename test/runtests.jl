using Test
using DynSolve

@testset "DynSolve end-to-end pipeline" begin
    ## placeholder model
    fake_model = Dict(:placeholder => true)

    ## steady state
    ss = steadystate(fake_model)
    @test isa(ss, Dict)
    @test haskey(ss, :k)
    @test haskey(ss, :c)
    @test haskey(ss, :y)

    ## linearization
    lin = linearize(fake_model, ss)
    @test isa(lin, Dict)
    @test haskey(lin, :A)
    @test haskey(lin, :B)

    ## solve with perturbation solver
    sol = solve(lin, PerturbationSolver())
    @test isa(sol, Dict)
    @test haskey(sol, :G1)
    @test haskey(sol, :impact)

    ## impulse response
    irf = impulse_response(sol; shock=:εA, horizon=20)
    @test isa(irf, Dict)
    @test haskey(irf, :y)
    @test length(irf[:y]) == 20

    ## analyze + report
    rep = analyze(fake_model, ss, sol, irf)
    @test isa(rep, Dict)
    @test haskey(rep, :summary)

    export_report(rep, "rbc_report.md")
    @test isfile("rbc_report.md")
end