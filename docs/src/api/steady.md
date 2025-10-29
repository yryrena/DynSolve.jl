# Steady State Computation

## `steadystate(model::Model)`

Computes the **deterministic steady state** of a model.

```julia
ss = steadystate(model)
```


### Returns

A `Dict{Symbol, Float64}` mapping each variable name to its steady-state value, e.g.

```julia
Dict(:k => 1.0, :c => 0.5, :y => 1.0)
```

### Internals

- The steady-state equations are derived from the model’s symbolic equations.
- Nonlinear equations are solved using [`NLsolve.jl`](https://github.com/JuliaNLSolvers/NLsolve.jl).
- Initial guesses can later be passed as an argument (planned).

 

## Example

```julia
ss = steadystate(model)
println(ss[:k])    ## access steady-state capital
```

 
## Notes

- For models with exogenous AR(1) shocks, the steady-state value is typically zero.
- The steady-state module can later support symbolic steady states using `ModelingToolkit.solve_for`.
