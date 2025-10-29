# Reporting

## `export_report(report::Dict, path::String)`

Exports a **markdown or HTML report** summarizing the model analysis.

```julia
export_report(report, "rbc_report.md")
```

### Behavior

- writes a simple markdown file containing model summary and results 
- can later be extended to generate plots and styled HTML output 

 

## Example

```julia
report = Dict(:summary => "Steady state and IRFs computed successfully.")
export_report(report, "results/summary.md")
```

Creates a file:

```markdown
# DynSolve Report
## Summary
Steady state and IRFs computed successfully.
```

 

## Future Extensions

- integration with [`Weave.jl`](https://github.com/JunoLab/Weave.jl) for LaTeX and PDF reports 
- auto-embedding plots from `Plots.jl` 
- comparative analysis tables across models 
 
------

## Notes

Reports are designed to be lightweight and reproducible: plain text files, version-controlled with the model code.
