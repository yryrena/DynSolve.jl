using Test
using DynSolve

@testset "@dgesys basic parsing" begin
    model = @dgesys begin
        var c(t) k(t+1)
        param β=0.99 δ=0.025
        eq Euler 1/c(t) ~ β * (1/c(t+1)) * (1-δ)
    end

    @test isa(model, DynSolve.ModelSpec.Model)

    ## variables
    @test sort(model.variables) == sort([:c, :k])

    ## parameters
    @test haskey(model.parameters, :β)
    @test haskey(model.parameters, :δ)
    @test model.parameters[:β] ≈ 0.99
    @test model.parameters[:δ] ≈ 0.025

    ## equations
    @test length(model.equations) == 1
    eq1 = model.equations[1]
    @test eq1.name === :Euler
    @test eq1.expr isa Expr
end