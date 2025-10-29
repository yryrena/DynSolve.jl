# Example: New Keynesian Model

This example demonstrates how to use DynSolve.jl for a **New Keynesian (NK)** model.

---

## Model Setup

```julia
using DynSolve

nk_model = @dgesys begin
    var x(t), pi(t), i(t)
    shock εd(t), εm(t)
    param β=0.99, κ=0.1, φπ=1.5, φx=0.5, ρd=0.8, ρm=0.5, σd=0.01, σm=0.01

    IS        ~ x(t) ~ x(t+1) - (i(t) - pi(t+1))
    NKPC      ~ pi(t) ~ β*pi(t+1) + κ*x(t)
    Taylor    ~ i(t) ~ φπ*pi(t) + φx*x(t) + εm(t)

    demand    ~ εd(t+1) ~ ρd*εd(t) + σd*εd(t)
    monetary  ~ εm(t+1) ~ ρm*εm(t) + σm*εm(t)
end
```

## Compute and Solve

```julia
ss = steadystate(nk_model)
lin = linearize(nk_model, ss)
sol = solve(lin, PerturbationSolver())
```

## Impulse Response: Monetary Policy Shock

```julia
irf = impulse_response(sol; shock=:εm, horizon=20)
```

## Reporting

```julia
report = analyze(nk_model, ss, sol, irf)
export_report(report, "nk_report.md")
```


## Notes
This stylized NK example illustrates:
- sticky prices via the Phillips Curve 
- monetary policy reaction through a Taylor rule 
- demand shock propagation through the IS curve 

While simple, it provides a template for more complex DSGE systems.