# Report.jl
# Report generation / export

using PrettyTables
using Plots

"""
    export_report(report::Dict, path::String)

Write a minimal Markdown report to `path`.
"""
function export_report(report::Dict, path::String)
    @info "Exporting report to $path"
    open(path, "w") do io
        println(io, "# DynSolve Report\n")
        println(io, "## Summary\n")
        println(io, report[:summary])
    end
    return nothing
end