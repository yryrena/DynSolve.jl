using Test
using DynSolve

@testset "@dgesys basic parsing" begin
    model = @dgesys begin
        var(:c, :k)
        param(β = 0.99, δ = 0.025)
        equation(:Euler, :(1/c - β * (1/c) * (1 - δ)))
    end
    @test isa(model, Model)

    ## variables collected
    @test sort(model.variables) == sort([:c, :k])

    ## parameters collected
    @test haskey(model.parameters, :β)
    @test haskey(model.parameters, :δ)
    @test model.parameters[:β] ≈ 0.99
    @test model.parameters[:δ] ≈ 0.025

    ## equations collected
    @test length(model.equations) == 1
    eq1 = model.equations[1]
    @test eq1.name === :Euler
    @test eq1.expr isa Expr
end


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