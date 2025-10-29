using Documenter, DynSolve

makedocs(
    sitename = "DynSolve.jl",
    modules = [DynSolve],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "Quick Start" => "quickstart.md",
        "API" => [
            "Model" => "api/model.md",
            "Steady State" => "api/steady.md",
            "Linearization" => "api/linear.md",
            "Solvers" => "api/solvers.md",
            "Analysis" => "api/analysis.md",
            "Report" => "api/report.md"
        ],
        "Examples" => [
            "RBC" => "examples/rbc.md",
            "New Keynesian" => "examples/nk.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/<你的用户名>/DynSolve.jl.git",
    branch = "gh-pages"
)