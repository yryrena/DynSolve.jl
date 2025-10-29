using DynSolve

"""
Simple New Keynesian (NK) demo model.

This is a stylized 3-equation NK setup:
1. IS curve (consumption Euler / output gap dynamics)
2. New Keynesian Phillips Curve (inflation dynamics)
3. Taylor rule for monetary policy

The purpose of this example is to show that DynSolve.jl is not limited
to RBC-style real business cycle models, but can also represent sticky-price
monetary models.
"""

nk_model = @dgesys begin
    ## endogenous variables
    var x(t)      ## output gap
    var pi(t)     ## inflation
    var i(t)      ## nominal interest rate

    ## shocks
    shock εd(t)   ## demand shock
    shock εm(t)   ## monetary policy shock

    ## parameters (placeholder values)
    param β=0.99, κ=0.1, φπ=1.5, φx=0.5, ρd=0.8, ρm=0.5, σd=0.01, σm=0.01

    ## demand / IS curve:
    ## x_t = E_t[x_{t+1}] - (1/σ)( i_t - E_t[pi_{t+1}] )
    IS        ~ x(t) ~ x(t+1) - (i(t) - pi(t+1))

    ## NK Phillips Curve:
    ## pi_t = β E_t[pi_{t+1}] + κ x_t
    NKPC      ~ pi(t) ~ β * pi(t+1) + κ * x(t)

    ## Taylor rule:
    ## i_t = φπ pi_t + φx x_t + εm_t
    Taylor    ~ i(t) ~ φπ * pi(t) + φx * x(t) + εm(t)

    ## shock processes (AR(1), simple form placeholder):
    demand   ~ εd(t+1) ~ ρd * εd(t) + σd * εd(t)
    monetary ~ εm(t+1) ~ ρm * εm(t) + σm * εm(t)
end

println("Computing steady state for NK model...")
nk_ss = steadystate(nk_model)
println("nk_ss = ", nk_ss)

println("Linearizing NK model...")
nk_lin = linearize(nk_model, nk_ss; order=1)

println("Solving NK model with perturbation solver...")
nk_sol = solve(nk_lin, PerturbationSolver())

println("Computing impulse responses to a monetary policy shock εm ...")
nk_irf = impulse_response(nk_sol; shock=:εm, horizon=20)

println("Analyzing NK model...")
nk_report = analyze(nk_model, nk_ss, nk_sol, nk_irf)

println("Export markdown report to nk_report.md ...")
export_report(nk_report, "nk_report.md")

println("Done!!")