# Report.jl
# Report generation / export

using Plots
using PrettyTables

"""
    export_report(report::Dict, path::String)

Write a minimal Markdown report to `path`.
"""
function export_report(report::Dict, path::String)
    @info "Exporting report to $path"
    open(path, "w") do io
        println(io, "# DynSolve Report")
        println(io, "## Summary")
        println(io, report[:summary])
    end
    return nothing
end