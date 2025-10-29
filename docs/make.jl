using Documenter
using DynSolve

makedocs(
    sitename = "DynSolve.jl",
    modules = [DynSolve],
    format = Documenter.HTML(),
    checkdocs = :none,  # <- allow missing doc references for now
    pages = [
        "Home" => "index.md",
        "Quick Start" => "quickstart.md",
        "API" => [
            "Model"         => "api/model.md",
            "Steady State"  => "api/steady.md",
            "Linearization" => "api/linear.md",
            "Solvers"       => "api/solvers.md",
            "Analysis"      => "api/analysis.md",
            "Report"        => "api/report.md",
        ],
        "Examples" => [
            "RBC"          => "examples/rbc.md",
            "New Keynesian" => "examples/nk.md",
        ],
    ],
)

## deployment step for GitHub Pages.
deploydocs(
    repo = "github.com/yryrena/DynSolve.jl.git",
    branch = "gh-pages",
)