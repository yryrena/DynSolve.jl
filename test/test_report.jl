using Test
using DynSolve

@testset "Report export" begin
    fake_report = Dict(:summary => "Analysis complete")
    export_report(fake_report, "tmp_report.md")

    @test isfile("tmp_report.md")
end