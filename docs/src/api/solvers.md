# Solvers

DynSolve.jl provides multiple solver backends for dynamic systems.

Each solver implements a unified interface:

```julia
sol = solve(system, solver)
```


## 1. `PerturbationSolver()`

Linear perturbation (Blanchard–Kahn) approach.
 Used for standard DSGE or RBC models.

```julia
sol = solve(lin, PerturbationSolver())
```

### Output

```julia
Dict(:G1 => [0.95], :impact => [0.1])
```

 

## 2. `ProjectionSolver()`

Nonlinear **projection / collocation** method.
 Suitable for models with large shocks or occasionally binding constraints.

```julia
sol = solve(model, ProjectionSolver())
```

(Currently a placeholder — to be implemented in the next version.)

 

## 3. `VFISolver()`

Value Function Iteration (VFI) for heterogeneous-agent models (HANK / incomplete markets).

```julia
sol = solve(model, VFISolver())
```

Also a placeholder for now, but designed to handle dynamic programming formulations.
 

## Design Philosophy

| Solver             | Type                | Use Case             |
| ------------------ | ------------------- | -------------------- |
| PerturbationSolver | Linear / local      | DSGE / RBC           |
| ProjectionSolver   | Global nonlinear    | OBC / large shocks   |
| VFISolver          | Dynamic programming | Heterogeneous agents |

 

## Example

```julia
sol = solve(lin, PerturbationSolver())
``` 