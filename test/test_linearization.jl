using Test
using DynSolve

@testset "Linearization basics" begin
    dummy_model = @dgesys begin
        ## placeholder model definition
    end

    ss = steadystate(dummy_model)
    lin = linearize(dummy_model, ss; order=1)

    @test isa(lin, Dict)
    @test haskey(lin, :A)
end