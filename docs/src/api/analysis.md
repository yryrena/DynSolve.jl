# Analysis and Impulse Responses

## `impulse_response(solution; shock, horizon=40)`

Generates **impulse response functions (IRFs)** given a solved model.

```julia
irf = impulse_response(sol; shock=:εA, horizon=40)
```

### Returns

A dictionary of time series (arrays):

```julia
Dict(:y => [1.0, 0.95, 0.9, ...])
```

 

## `analyze(model, ss, sol, irf)`

Computes and summarizes post-solution statistics.

```julia
report = analyze(model, ss, sol, irf)
```

### Returns

A dictionary containing:

```julia
Dict(:summary => "Analysis complete")
```
 

## Planned Features

- variance decomposition
- simulation of stochastic paths
- comparison across models (e.g., policy experiments)
- PrettyTables output for markdown / HTML reports

 
## Example

```julia
irf = impulse_response(sol; shock=:εA)
report = analyze(model, ss, sol, irf)
```