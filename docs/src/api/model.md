# Model Specification (`@dgesys` and `Model`)

DynSolve models are defined **symbolically** using the `@dgesys` macro, built on top of `ModelingToolkit.jl`.  
This makes the model human-readable, reproducible, and automatically differentiable.
 
## `@dgesys` Macro

```julia
model = @dgesys begin
    var c(t), k(t), y(t)
    shock εA(t)
    param α=0.36, β=0.99, δ=0.025

    y(t)      ~ k(t)^α
    Euler     ~ 1/c(t) ~ β*(1/c(t+1))*(1+α*k(t+1)^(α-1)-δ)
    k(t+1)    ~ y(t) - c(t) + (1-δ)*k(t)
end
```

### Keywords

| Keyword | Description                                 |
| ------- | ------------------------------------------- |
| `var`   | Endogenous variables depending on time `t`. |
| `shock` | Exogenous stochastic processes.             |
| `param` | Model parameters (with initial values).     |
| `~`     | Represents an equation (equality).          |



## `Model` Struct

```julia
struct Model
    variables::Vector{Symbol}
    shocks::Vector{Symbol}
    parameters::Vector{Symbol}
    equations::Vector{Equation}
end
```

Each `@dgesys` call returns a `Model` object that stores the symbolic system and metadata for steady-state and solution steps.

 

## Notes
- You can include expectations (`E_t[x(t+1)]`) symbolically; future releases will map this to perturbation logic.
- Parameters can be re-assigned after model creation:
  ```julia
  model.parameters[:β] = 0.98
  ```
- Equations are internally represented as `ModelingToolkit.Equation` objects.

