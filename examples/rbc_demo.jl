using DynSolve

model = @dgesys begin
    var c(t), k(t), y(t), r(t)
    shock εA(t)
    param α=0.36, β=0.99, δ=0.025, ρA=0.9, σA=0.01

    y(t) ~ exp(a(t)) * k(t)^α
    a(t+1) ~ ρA * a(t) + σA * εA(t)
    Euler  ~ 1/c(t) ~ β * (1/c(t+1)) * (1 + r(t+1) - δ)
    k(t+1) ~ y(t) - c(t) + (1-δ)*k(t)
    r(t)   ~ α * y(t)/k(t)
end

ss = steadystate(model)
lin = linearize(model, ss)
sol = solve(lin, DynSolve.PerturbationSolver.PerturbationSolver())
irf = impulse_response(sol; shock=:εA)
report = analyze(model, ss, sol, irf)
export_report(report, "rbc_report.md")