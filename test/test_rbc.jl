using Test, DynSolve

@testset "Basic RBC Model" begin
    model = @dgesys begin
        ## simplified symbolic form
    end

    ss = steadystate(model)
    @test haskey(ss, :k)

    lin = linearize(model, ss)
    sol = solve(lin, DynSolve.PerturbationSolver.PerturbationSolver())
    irf = impulse_response(sol; shock=:εA)
    report = analyze(model, ss, sol, irf)

    export_report(report, "tmp_report.md")
    @test isfile("tmp_report.md")
end