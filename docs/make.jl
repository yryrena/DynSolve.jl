using Documenter
using DynSolve

makedocs(;
    modules = [DynSolve],
    sitename = "DynSolve.jl",
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "Quickstart" => "quickstart.md",
        "API" => [
            "Model specification" => "api/model.md",
            "Steady state"        => "api/steady.md",
            "Linearization"       => "api/linear.md",
            "Solvers"             => "api/solvers.md",
            "Analysis / IRF"      => "api/analysis.md",
            "Report generation"   => "api/report.md",
        ],
        "Examples" => [
            "RBC" => "examples/rbc.md",
            "New Keynesian" => "examples/nk.md",
        ],
    ],
)